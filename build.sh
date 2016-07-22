#!/bin/bash

# Usage: ./build.sh [VERSION]

source .env
[[ $# == 1 ]] && VERSION=$1 && BUILD_WITH="--build-arg VERSION=$VERSION"

echo "Building ownCloud standard $VERSION"

docker pull owncloud/owncloud-base
docker build -t owncloud/server:$VERSION --build-arg VERSION=$VERSION .

