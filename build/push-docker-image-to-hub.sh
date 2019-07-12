#!/bin/bash

set -e
set -u
set -o pipefail

DOCKER_USER_NAME="meterianbot"
VERSION="v$(cat ../version.txt)"
DOCKER_FULL_IMAGE_NAME="meterianbot/meterian-scanner-docker:${VERSION}"

findImage() {
	IMAGE_NAME=$1
	echo $(docker images ${IMAGE_NAME} -q | head -n1 || true)
}

IMAGE_FOUND="$(findImage ${DOCKER_FULL_IMAGE_NAME})"
if [[ -z "${IMAGE_FOUND}" ]]; then
    echo "Docker image '${DOCKER_FULL_IMAGE_NAME}' not found in the local repository"
    IMAGE_FOUND="$(findImage ${IMAGE_NAME})"
    if [[ -z "${IMAGE_FOUND}" ]]; then
    	echo "Docker image '${IMAGE_NAME}' not found in the local repository"
    	exit 1
    else 
    	echo "Docker image '${IMAGE_NAME}' found in the local repository"
    fi
else
    echo "Docker image '${DOCKER_FULL_IMAGE_NAME}' found in the local repository"
fi

docker tag ${IMAGE_FOUND} ${DOCKER_FULL_IMAGE_NAME}
docker login --username=${DOCKER_USER_NAME} --password=${DOCKER_PASSWORD:-}
docker push ${DOCKER_FULL_IMAGE_NAME}