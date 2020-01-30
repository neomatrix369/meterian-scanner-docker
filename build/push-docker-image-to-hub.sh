#!/bin/bash

set -e
set -u
set -o pipefail

METERIAN_REPO_NAME=$(cat ../docker_repository.txt)

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

isImageVersionOnDockerHub() {
    version=$1
    
    res=1
    if [[ $(curl -o /dev/null -s -w "%{http_code}\n" "https://hub.docker.com/v2/repositories/${METERIAN_REPO_NAME}/tags/${version}") -eq 200 ]];
    then
        res=0
    fi
    
    echo "${res}"
}

if [[ "$#" -ne 0 ]];
then
    docker login --username=${DOCKER_USER_NAME} --password=${DOCKER_PASSWORD:-}

    for variant in ${@}; do

        if [[ "${variant}" = "full" ]];
        then
            image_tag="$(cat ../version.txt)"
            docker_full_image_name="${METERIAN_REPO_NAME}:${image_tag}"
            docker_full_image_name_latest="${METERIAN_REPO_NAME}:latest"
        else
            image_tag="$(cat variants/${variant}/version.txt)-${variant}"
            docker_full_image_name="${METERIAN_REPO_NAME}:${image_tag}"
            docker_full_image_name_latest="${METERIAN_REPO_NAME}:latest-${variant}"
        fi

        image_found="$(findImage ${docker_full_image_name})"
        if [[ -z "${image_found}" ]]; then
            echo "Docker image '${docker_full_image_name}' not found in the local repository"
            continue
        else
            echo "Docker image '${docker_full_image_name}' found in the local repository"
            if [[ ! "$(isImageVersionOnDockerHub ${image_tag})" -eq 0 ]];
            then
                pushDockerImage ${image_found} ${docker_full_image_name} ${docker_full_image_name_latest}
            else
                echo "Aborting image upload: '${docker_full_image_name}' already exists on docker hub"
            fi
        fi

    done

    docker logout
else 
    echo No variants to build were provided
fi