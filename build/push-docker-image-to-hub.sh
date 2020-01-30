#!/bin/bash

set -e
set -u
set -o pipefail

pushDockerImage() {
    image_id="${1}"
    docker_full_image_name="${2}"
    docker_full_image_name_latest="${3}"

    docker tag ${image_id} ${docker_full_image_name}
    docker tag ${image_id} ${docker_full_image_name_latest}
    docker push ${docker_full_image_name}
    docker push ${docker_full_image_name_latest}
}

findImage() {
	IMAGE_NAME=$1
	echo $(docker images ${IMAGE_NAME} -q | head -n1 || true)
}

if [[ "$#" -ne 0 ]];
then
    docker login --username=${DOCKER_USER_NAME} --password=${DOCKER_PASSWORD:-}

    for variant in ${@}; do

        if [[ "${variant}" = "full" ]];
        then
            docker_full_image_name="meterian/cli-canary:$(cat ../version.txt)"
            docker_full_image_name_latest="meterian/cli-canary:latest"
        else
            docker_full_image_name="meterian/cli-canary:$(cat variants/${variant}/version.txt)-${variant}"
            docker_full_image_name_latest="meterian/cli-canary:latest-${variant}"
        fi

        image_found="$(findImage ${docker_full_image_name})"
        if [[ -z "${image_found}" ]]; then
            echo "Docker image '${docker_full_image_name}' not found in the local repository"
            continue
        else
            echo "Docker image '${docker_full_image_name}' found in the local repository"
        fi
        pushDockerImage ${image_found} ${docker_full_image_name} ${docker_full_image_name_latest}

    done

    docker logout
else 
    echo No variants to build were provided
fi