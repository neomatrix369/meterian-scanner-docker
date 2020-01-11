#!/bin/bash

set -e
set -o pipefail

VERSION="$(cat ../version.txt)"
DOCKER_FULL_IMAGE_NAME="meterianbot/meterian-scanner-docker:${VERSION}"
BUILD=${CIRCLE_BUILD_NUM:-000}
VERSION_WITH_BUILD=${VERSION}.${BUILD}

echo "~~~~~~ Building the docker container for the Meterian Scanner client"
docker build -t ${DOCKER_FULL_IMAGE_NAME} --build-arg VERSION=${VERSION_WITH_BUILD} .
