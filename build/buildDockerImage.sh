#!/bin/bash

set -e
set -o pipefail

## TODO --build-all

isValidVersion() {
    version=$1 && shift
    versions=($@)

    result=1
    for ver in ${versions[@]}; do
        if [[ "${version}" = "${ver}" ]];
        then
            result=0
            break
        fi
    done

    echo ${result}
}

buildImage() {
    VERSION=$1
    DOCKER_IMAGE_NAME="meterian/cli"
    DOCKER_FULL_IMAGE_NAME="${DOCKER_IMAGE_NAME}:${VERSION}"
    BUILD=${CIRCLE_BUILD_NUM:-000}
    VERSION_WITH_BUILD=${VERSION}.${BUILD}

    echo "~~~~~~ Building the docker container for the Meterian Scanner client"
    if [[ "${VERSION}" = "full" ]];
    then
        docker build -t ${DOCKER_FULL_IMAGE_NAME} -t ${DOCKER_IMAGE_NAME}:latest --build-arg VERSION=${VERSION_WITH_BUILD} -f versions/full/Dockerfile .
    else
        docker build -t ${DOCKER_FULL_IMAGE_NAME} -t ${DOCKER_IMAGE_NAME}:latest-${VERSION} --build-arg VERSION=${VERSION_WITH_BUILD} -f versions/${VERSION}/Dockerfile .
    fi
}

getVersions() {
    IFS=$'\r\n'
    file=versions/versions.txt

    versions=()
    while read -r version
    do
        versions=("${versions[@]}" "$version")
    done < "$file"

    echo "${versions[@]}"
}

VERSIONS=$(getVersions)
# # test checking VERSIONS 
#echo "${VERSIONS[@]}"

if [[ "$#" -eq 0 ]];
then
    echo Error: no version provided
    exit 1
fi

if [[ "$*" =~ "--build-all" ]];
then
    echo Building all versions...
    for version in ${VERSIONS[@]}; do
        buildImage "${version}"
    done
else
    echo "Specific version found (${1})"
    if [[ "$(isValidVersion ${1} ${VERSIONS[@]})" -eq 0 ]];
    then
        echo "${1@Q} is a supported version"
        buildImage "${1}"
    else
        echo "${1@Q} is not a supported version"
    fi
fi