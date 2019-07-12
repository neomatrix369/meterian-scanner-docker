#!/bin/bash

set -e
set -u
set -o pipefail

WORK_DIR=/home/

mkdir -p ${WORK_DIR}/.meterian/
curl -o ${WORK_DIR}/.meterian/meterian-cli.jar -O -J -L \
         https://www.meterian.com/latest-client-canary

METERIAN_ARGS=${METERIAN_ARGS:-"$*"}
java -jar ${WORK_DIR}/.meterian/meterian-cli.jar ${METERIAN_ARGS}