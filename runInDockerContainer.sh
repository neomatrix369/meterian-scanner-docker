#!/bin/bash

set -e
set -u
set -o pipefail

VERSION="v$(cat version.txt)"
DOCKER_FULL_IMAGE_NAME="meterian-bot/meterian-scanner-docker:${VERSION}"

WORK_DIR=/home/
docker run -it                                             \
           --workdir ${WORK_DIR}                           \
           --volume $(pwd)/:${WORK_DIR}                    \
           --env METERIAN_API_TOKEN=${METERIAN_API_TOKEN}  \
           --env METERIAN_CLI_ARGS=${METERIAN_CLI_ARGS:-}  \
           ${DOCKER_FULL_IMAGE_NAME}                       \
           /bin/bash