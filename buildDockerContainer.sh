#!/bin/bash

set -e
set -u
set -o pipefail

VERSION="v$(cat version.txt)"
DOCKER_FULL_IMAGE_NAME="meterian-bot/meterian-scanner-docker:${VERSION}"

docker pull ${DOCKER_FULL_IMAGE_NAME} || true
docker build                         \
       -t ${DOCKER_FULL_IMAGE_NAME}  \
       .