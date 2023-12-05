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

BUILD_NO_CACHE=""
if [[ "$*" =~ "--no-cache" ]];
then
    BUILD_NO_CACHE="--no-cache"
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
        if [[ "$(echo "$variant" | grep -o arm64)" == "arm64" ]]; then
            docker buildx build ${BUILD_NO_CACHE:-} --platform arm64 --output type=docker -t ${DOCKER_FULL_IMAGE_NAME} -t ${DOCKER_IMAGE_NAME}:latest-${VARIANT} \
                --build-arg VERSION=${VERSION_WITH_BUILD} -f variants/${VARIANT}/Dockerfile .            
        else
            docker build ${BUILD_NO_CACHE:-} -t ${DOCKER_FULL_IMAGE_NAME} -t ${DOCKER_IMAGE_NAME}:latest-${VARIANT} --build-arg VERSION=${VERSION_WITH_BUILD} \
                        -f variants/${VARIANT}/Dockerfile .
        fi
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
    docker build ${BUILD_NO_CACHE:-} -t ${DOCKER_FULL_IMAGE_NAME}-tmp -t ${DOCKER_IMAGE_NAME}:latest-tmp --build-arg VERSION=${VERSION_WITH_BUILD} .

    DOCKER_BIN="$(which docker)"
    echo "~~~~~~ Squashing ${DOCKER_FULL_IMAGE_NAME} & ${DOCKER_IMAGE_NAME}:latest"
    docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
                    -v "${DOCKER_BIN}":"${DOCKER_BIN}" \
                    meterian/docker-squash:latest -t ${DOCKER_FULL_IMAGE_NAME} ${DOCKER_FULL_IMAGE_NAME}-tmp
    docker tag ${DOCKER_FULL_IMAGE_NAME} ${DOCKER_IMAGE_NAME}:latest
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

VARIANTS=$(getVariants)
# # test checking VARIANTS 
#echo "${VARIANTS[@]}"

if [[ "$#" -eq 0 || "$*" =~ "full" ]];
then
    buildFullImage
    exit
fi

if [[ "$*" =~ "--build-all" ]];
then
    echo Building all...

    # build full image unless we want it to be skipped
    if [[ -z "$(echo "$VARIANT_SKIP" | grep -o full)" ]]; then
        buildFullImage
    fi

    for variant in ${VARIANTS[@]}; do
        if [[ "$variant" == "openjdk11" ]]; then
            echo "Build of variant openjdk11 is temporarily skipped from option build-all"
            continue
        fi
        buildVariantImage "${variant}"
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