#!/bin/bash

set -e
set -u
set -o pipefail

SCRIPT_CURRENT_DIR="$(dirname $0)"

VERSION="v$(cat ${SCRIPT_CURRENT_DIR}/version.txt)"
DOCKER_FULL_IMAGE_NAME="meterianbot/meterian-scanner-docker:${VERSION}"

METERIAN_CLI_ARGS="${METERIAN_CLI_ARGS:-}"

WORKSPACE=${1:-$(pwd)}
CONTAINER_WORKSPACE=/workspace

if [[ ${DEBUG:-} = "true" ]]; then
	CUSTOM_ENTRYPOINT="--entrypoint /bin/bash"
fi

docker run -it --rm                                        \
           --volume ${WORKSPACE}:${CONTAINER_WORKSPACE}:ro \
           --workdir ${CONTAINER_WORKSPACE}                \
           --env METERIAN_API_TOKEN=${METERIAN_API_TOKEN}  \
           --env METERIAN_CLI_ARGS=${METERIAN_CLI_ARGS}    \
           ${CUSTOM_ENTRYPOINT:-}                          \
           ${DOCKER_FULL_IMAGE_NAME}