#!/usr/bin/env bash
# Run one part of ownCloud core's acceptance tests against a server image.
#
# usage: run-part.sh <image> <php> <type> <part> <parts> <tags>
#   image  server image under test, e.g. owncloud/server:test
#   php    PHP version of the test runner (owncloudci/php:<php>), 7.4 or 8.3
#   type   suite type for run.sh: api or cli
#   part   part to run, 1..parts (run.sh --part)
#   tags   Behat tag filter
#
# environment:
#   QA_DIR                  extracted owncloud-complete-*-qa tarball with Behat installed
#   TESTING_DIR             the owncloud/testing app
#   EXPECTED_FAILURES_FILE  optional, a run.sh expected-failures list
#   LOG_DIR                 where to write the server and database logs
set -uo pipefail

image=$1 php=$2 type=$3 part=$4 parts=$5 tags=$6
: "${QA_DIR:?}" "${TESTING_DIR:?}" "${LOG_DIR:?}"
net=acceptance db=acceptance-db redis=acceptance-redis srv=acceptance-server
mkdir -p "${LOG_DIR}"

cleanup() {
  docker logs "${srv}" >"${LOG_DIR}/server.log" 2>&1
  docker logs "${db}" >"${LOG_DIR}/database.log" 2>&1
  docker logs "${redis}" >"${LOG_DIR}/redis.log" 2>&1
  docker rm -f "${srv}" "${db}" "${redis}" >/dev/null 2>&1
  docker network rm "${net}" >/dev/null 2>&1
}
trap cleanup EXIT

docker network create "${net}" >/dev/null

docker run -d --name "${db}" --network "${net}" \
  -e MARIADB_ROOT_PASSWORD=owncloud -e MARIADB_DATABASE=owncloud \
  -e MARIADB_USER=owncloud -e MARIADB_PASSWORD=owncloud \
  mariadb:10.11 --max-allowed-packet=128M --innodb-log-file-size=64M >/dev/null
ready=false
for _ in $(seq 60); do
  docker exec "${db}" healthcheck.sh --connect --innodb_initialized >/dev/null 2>&1 && ready=true && break
  sleep 2
done
[[ "${ready}" == true ]] || { echo "MariaDB did not become ready" >&2; exit 1; }

# Redis for caching and file locking, as recommended for production. With the
# image's default database locking, uploads into a local storage mount created
# during a test failed with 423 Locked, differently from run to run.
docker run -d --name "${redis}" --network "${net}" redis:7 >/dev/null
ready=false
for _ in $(seq 30); do
  [[ "$(docker exec "${redis}" redis-cli ping 2>/dev/null)" == PONG ]] && ready=true && break
  sleep 1
done
[[ "${ready}" == true ]] || { echo "Redis did not start" >&2; exit 1; }

docker run -d --name "${srv}" --network "${net}" \
  -e OWNCLOUD_DOMAIN="${srv}:8080" -e OWNCLOUD_TRUSTED_DOMAINS="${srv},localhost" \
  -e OWNCLOUD_DB_TYPE=mysql -e OWNCLOUD_DB_HOST="${db}" -e OWNCLOUD_DB_NAME=owncloud \
  -e OWNCLOUD_DB_USERNAME=owncloud -e OWNCLOUD_DB_PASSWORD=owncloud \
  -e OWNCLOUD_ADMIN_USERNAME=admin -e OWNCLOUD_ADMIN_PASSWORD=admin \
  -e OWNCLOUD_REDIS_ENABLED=true -e OWNCLOUD_REDIS_HOST="${redis}" \
  "${image}" >/dev/null
# the image has no HEALTHCHECK; the entrypoint logs this once installation is done.
# Capture the logs first: under pipefail, grep -q closing the pipe early can fail it.
ready=false
for _ in $(seq 120); do
  logs=$(docker logs "${srv}" 2>&1)
  [[ "${logs}" == *'Starting apache daemon'* ]] && ready=true && break
  [[ "$(docker inspect -f '{{.State.Running}}' "${srv}")" == true ]] || break
  sleep 3
done
[[ "${ready}" == true ]] || { echo "ownCloud server did not start" >&2; exit 1; }
sleep 3

docker cp "${TESTING_DIR}" "${srv}:/var/www/owncloud/apps/testing" &&
  docker exec -u 0 "${srv}" chown -R www-data:root /var/www/owncloud/apps/testing &&
  docker exec "${srv}" occ app:enable testing &&
  docker exec "${srv}" occ status ||
  { echo "installing the testing app failed" >&2; exit 1; }

expected=()
if [[ -n "${EXPECTED_FAILURES_FILE:-}" ]]; then
  expected=(-v "${EXPECTED_FAILURES_FILE}:/expected-failures.md:ro" -e EXPECTED_FAILURES_FILE=/expected-failures.md)
fi

docker run --rm --network "${net}" -v "${QA_DIR}:/src" -w /src "${expected[@]}" \
  -e TEST_SERVER_URL="http://${srv}:8080" \
  -e ALT1_USER_PASSWORD='AaBb2Cc3Dd!' -e ALT2_USER_PASSWORD='AaBb2Cc4Dd!' \
  -e ALT3_USER_PASSWORD='AaBb2Cc5Dd!' -e ALT4_USER_PASSWORD='AaBb2Cc6Dd!' \
  -e ALTERNATE_ADMIN_PASSWORD='AaBb2Cc9D!' -e PUBLIC_LINK_SHARE_PASSWORD='AaBb2Cc3d!' \
  -e REGULAR_USER_PASSWORD='AaBb2Cc7Dd!' -e SUB_ADMIN_PASSWORD='AaBb2Cc8Dd!' \
  -e PLAIN_OUTPUT=true \
  "owncloudci/php:${php}" \
  bash tests/acceptance/run.sh --remote --type "${type}" --tags "${tags}" --part "${part}" "${parts}"
