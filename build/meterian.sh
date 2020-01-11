#!/bin/bash

# recovering official path (thanks su for your weirdness)
export PATH=${XPATH}

# check we have the token
if [[ -z "${METERIAN_API_TOKEN:-}" ]]; then
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo " METERIAN_API_TOKEN environment variable must be defined with a valid API token "
    echo " Please create a token from your account at https://meterian.com/account/       "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-"
	exit -1
fi

# update the client if necessary
METERIAN_JAR=/tmp/meterian-cli.jar
curl -s -o ${METERIAN_JAR} -z ${METERIAN_JAR} "https://www.meterian.com/downloads/meterian-cli.jar"  >/dev/null

# launching the client
java -Duser.home=/tmp  -jar ${METERIAN_JAR} ${METERIAN_CLI_ARGS}

# dump version of dockerized tooling
cat /tmp/version.txt
