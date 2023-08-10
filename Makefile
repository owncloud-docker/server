# local build without drone.
#
# TODO: review, if this gets close to what drone does.
# NOTE: Many more labels are produced from inside the Dockerfile


VALUE    := $(shell grep '"value":'   .drone.star  | head -1 | cut -d'"' -f 4)
TARBALL  := $(shell grep '"tarball":' .drone.star  | head -1 | cut -d'"' -f 4)
TSTAMP   := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
REVISION := $(shell git rev-parse HEAD)

NAME     := local-owncloud-server:${VALUE}
SOURCE   := https://github.com/owncloud-docker/server.git 
URL      := https://github.com/owncloud-docker/server
PLATFORM := v20.04

	
all: ${PLATFORM}/owncloud.tar.bz2
	docker build --rm=true -f ${PLATFORM}/Dockerfile.amd64 -t ${NAME} ${PLATFORM} --pull=true --label org.opencontainers.image.created=${TSTAMP} --label org.opencontainers.image.revision=${REVISION} --label org.opencontainers.image.source=${SOURCE} --label org.opencontainers.image.url=${URL}
	@echo
	@echo Try: docker run --rm -ti -v /tmp/mnt/data:/mnt/data -p 8080:8080 ${NAME}

${PLATFORM}/owncloud.tar.bz2:
	@echo "fetching server version ${VALUE} ... "
	wget ${TARBALL} -O ${PLATFORM}/owncloud.tar.bz2

clean:
	rm -f ${PLATFORM}/owncloud.tar.bz2
	docker rmi ${NAME} || true
