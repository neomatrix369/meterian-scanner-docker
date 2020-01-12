#!/bin/bash

set -e
set -o pipefail

VERSION="$(cat ../version.txt)"
DOCKER_IMAGE_NAME="meterian/cli"
DOCKER_FULL_IMAGE_NAME="${DOCKER_IMAGE_NAME}:${VERSION}"
BUILD=${CIRCLE_BUILD_NUM:-000}
VERSION_WITH_BUILD=${VERSION}.${BUILD}

echo "~~~~~~ Building the docker container for the Meterian Scanner client"
docker build -t ${DOCKER_FULL_IMAGE_NAME} -t ${DOCKER_IMAGE_NAME}:latest --build-arg VERSION=${VERSION_WITH_BUILD} .
