#!/bin/bash

set -e
set -o pipefail

if [[ -z "${CIRCLE_CI_BRANCH:-}" ]]; then
    METERIAN_REPO_NAME=$(cat ../docker_repository.txt)
elif [[ "${CIRCLE_CI_BRANCH:-}" == "master" ]]; then
    METERIAN_REPO_NAME="meterian/cli"
else
    METERIAN_REPO_NAME="meterian/cli-canary"
fi

VARIANT_SKIP=${VARIANT_SKIP:-}

isValidVariant() {
    variant=$1 && shift
    variants=($@)

    result=1
    for var in ${variants[@]}; do
        if [[ "${variant}" = "${var}" ]];
        then
            result=0
            break
        fi
    done

    echo ${result}
}

shouldSkipVariant() {
    variant="$1"

    skip_variant="false"
    for variant_to_skip in $VARIANT_SKIP
    do
        if [[ "$variant_to_skip" == "$variant" ]];then
            skip_variant="true"
            break
        fi
    done

    echo "$skip_variant"
}

buildVariantImage() {
    VARIANT=$1
    VERSION="$(cat variants/${VARIANT}/version.txt)"
    DOCKER_IMAGE_NAME="${METERIAN_REPO_NAME}"
    DOCKER_FULL_IMAGE_NAME="${DOCKER_IMAGE_NAME}:${VERSION}-${VARIANT}"
    BUILD=${CIRCLE_BUILD_NUM:-000}
    VERSION_WITH_BUILD=${VERSION}-${VARIANT}.${BUILD}

    skip_variant="$(shouldSkipVariant $VARIANT)"

    if [[ "$skip_variant" == "false" ]]; then
        echo "~~~~~~ Building the docker image for the Meterian Scanner client - '$VARIANT variant'"
        docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t ${DOCKER_FULL_IMAGE_NAME} -t ${DOCKER_IMAGE_NAME}:latest-${VARIANT} \
                    --build-arg VERSION=${VERSION_WITH_BUILD} -f variants/${VARIANT}/Dockerfile --push .
    else
        echo "Skipping build for ${DOCKER_FULL_IMAGE_NAME} due to variant skip rule"
    fi
}

buildFullImage() {
    VERSION="$(cat ../version.txt)"
    DOCKER_IMAGE_NAME="${METERIAN_REPO_NAME}"
    DOCKER_FULL_IMAGE_NAME="${DOCKER_IMAGE_NAME}:${VERSION}"
    BUILD=${CIRCLE_BUILD_NUM:-000}
    VERSION_WITH_BUILD=${VERSION}.${BUILD}

    echo "~~~~~~ Building the full docker image for the Meterian Scanner client"
    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t ${DOCKER_FULL_IMAGE_NAME} -t ${DOCKER_IMAGE_NAME}:latest-${VARIANT} \
                --build-arg VERSION=${VERSION_WITH_BUILD} --push .
}

getVariants() {
    IFS=$'\r\n'
    echo "$(ls variants)" > variants/variants.txt
    file=variants/variants.txt

    variants=()
    while read -r variant
    do
        variants=("${variants[@]}" "$variant")
    done < "$file"

    rm "${file}"
    echo "${variants[@]}"
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

VARIANTS=$(getVariants)
# # test checking VARIANTS 
#echo "${VARIANTS[@]}"

if [[ "$#" -eq 0 ]];
then
    buildFullImage
    exit
fi

docker login --username=${DOCKER_USER_NAME} --password=${DOCKER_PASSWORD:-}

if [[ "$*" =~ "--build-all" ]];
then
    echo Building all...

    # build new full image unless we want it to be skipped
    if [[ -z "$(echo "$VARIANT_SKIP" | grep -o full)" ]]; then
        image_tag="$(cat ../version.txt)"
        if [[ ! "$(isImageVersionOnDockerHub ${image_tag})" -eq 0 ]];then
            buildFullImage
        else
            echo "Tag version ${image_tag} found on DockerHub, build will be skipped"
        fi
    fi

    for variant in ${VARIANTS[@]}; do
        image_tag="$(cat variants/${variant}/version.txt)-${variant}"
        if [[ ! "$(isImageVersionOnDockerHub ${image_tag})" -eq 0 ]];then
            buildVariantImage "${variant}"
        else
            echo "Tag version ${image_tag} found on DockerHub, build will be skipped"
        fi
    done
else
    echo "Specific variant build requested: ${1}"
    if [[ "$(isValidVariant ${1} ${VARIANTS[@]})" -eq 0 ]];
    then
        echo "'${1}' is a supported variant"
        buildVariantImage "${1}"
    else
        echo "'${1}' is not a supported variant"
    fi
fi