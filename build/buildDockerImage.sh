#!/bin/bash

set -e
set -u
set -o pipefail

VERSION="v$(cat ../version.txt)"
DOCKER_FULL_IMAGE_NAME="meterianbot/meterian-scanner-docker:${VERSION}"

echo "~~~~~~ Building the docker container for the Meterian Scanner client"
docker build                                    \
       -t ${DOCKER_FULL_IMAGE_NAME}             \
       --build-arg METERIAN_HOME=/meterian_home \
       .