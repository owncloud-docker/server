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
net=acceptance db=acceptance-db srv=acceptance-server
mkdir -p "${LOG_DIR}"

cleanup() {
  docker logs "${srv}" >"${LOG_DIR}/server.log" 2>&1
  docker logs "${db}" >"${LOG_DIR}/database.log" 2>&1
  docker rm -f "${srv}" "${db}" >/dev/null 2>&1
  docker network rm "${net}" >/dev/null 2>&1
}
trap cleanup EXIT

docker network create "${net}" >/dev/null

docker run -d --name "${db}" --network "${net}" \
  -e MARIADB_ROOT_PASSWORD=owncloud -e MARIADB_DATABASE=owncloud \
  -e MARIADB_USER=owncloud -e MARIADB_PASSWORD=owncloud \
  mariadb:10.11 --max-allowed-packet=128M --innodb-log-file-size=64M >/dev/null
for _ in $(seq 60); do
  docker exec "${db}" healthcheck.sh --connect --innodb_initialized >/dev/null 2>&1 && break
  sleep 2
done

docker run -d --name "${srv}" --network "${net}" \
  -e OWNCLOUD_DOMAIN="${srv}:8080" -e OWNCLOUD_TRUSTED_DOMAINS="${srv},localhost" \
  -e OWNCLOUD_DB_TYPE=mysql -e OWNCLOUD_DB_HOST="${db}" -e OWNCLOUD_DB_NAME=owncloud \
  -e OWNCLOUD_DB_USERNAME=owncloud -e OWNCLOUD_DB_PASSWORD=owncloud \
  -e OWNCLOUD_ADMIN_USERNAME=admin -e OWNCLOUD_ADMIN_PASSWORD=admin \
  "${image}" >/dev/null
# the image has no HEALTHCHECK; the entrypoint logs this once installation is done
for _ in $(seq 120); do
  docker logs "${srv}" 2>&1 | grep -q 'Starting apache daemon' && break
  sleep 3
done
sleep 3

docker cp "${TESTING_DIR}" "${srv}:/var/www/owncloud/apps/testing"
docker exec -u 0 "${srv}" chown -R www-data:root /var/www/owncloud/apps/testing
docker exec "${srv}" occ app:enable testing
docker exec "${srv}" occ status

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
