#!/bin/bash

set -e
set -u
set -o pipefail

VERSION="v$(cat version.txt)"
DOCKER_FULL_IMAGE_NAME="meterian-bot/meterian-scanner-docker:${VERSION}"

echo "~~~~~~ Downloading an existing docker container for the Meterian Scanner client"
docker pull ${DOCKER_FULL_IMAGE_NAME} || true

echo "~~~~~~ Building the docker container for the Meterian Scanner client"
docker build                         \
       -t ${DOCKER_FULL_IMAGE_NAME}  \
       .