#!/bin/bash

set -e
set -u
set -o pipefail

if [[ -z "${METERIAN_API_TOKEN:-}" ]]; then
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "METERIAN_API_TOKEN environment variable must be defined with a valid token respectively from your account on http://meterian.io"
	echo "Aborting container execution..."
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	exit -1
fi

echo "~~~~~~ Running the Meterian Scanner client"
METERIAN_CLI_ARGS=${METERIAN_CLI_ARGS:-"$*"}
java -jar ${HOME}/.meterian/meterian-cli.jar ${METERIAN_CLI_ARGS}