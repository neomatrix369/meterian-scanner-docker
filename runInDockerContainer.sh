#!/bin/bash

set -e
set -u
set -o pipefail

VERSION="v$(cat version.txt)"
DOCKER_FULL_IMAGE_NAME="meterianbot/meterian-scanner-docker:${VERSION}"

METERIAN_CLI_ARGS="${METERIAN_CLI_ARGS:-}"

if [[ ${DEBUG:-} = "true" ]]; then
	CUSTOM_ENTRYPOINT="--entrypoint /bin/bash"
fi

WORKSPACE=/workspace

docker run -it --rm                                        \
           --volume $(pwd)/:${WORKSPACE}:ro                \
           --workdir ${WORKSPACE}                          \
           --env METERIAN_API_TOKEN=${METERIAN_API_TOKEN}  \
           --env METERIAN_CLI_ARGS=${METERIAN_CLI_ARGS}    \
           ${CUSTOM_ENTRYPOINT:-}                          \
           ${DOCKER_FULL_IMAGE_NAME}