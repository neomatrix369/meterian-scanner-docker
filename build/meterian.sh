#!/bin/bash

# executing general initialisation script
#cat /tmp/init.sh
source /tmp/init.sh

exitWithErrorMessageWhenApiTokenIsUnset() {
	if [[ -z "${METERIAN_API_TOKEN:-}" ]] 
	then
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo " METERIAN_API_TOKEN environment variable must be defined with a valid API token "
		echo " Please create a token from your account at https://meterian.com/account/       "
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-"
		exit -1
	fi
}

# dump docker packaged version unless '--version' requested
if [[ ${METERIAN_CLI_ARGS} != *"--version"* ]]; then
    cat /tmp/version.txt
	exitWithErrorMessageWhenApiTokenIsUnset
fi

# meterian jar location
METERIAN_JAR=/tmp/meterian-cli.jar

# update the client if necessary
# curl -s -o ${METERIAN_JAR} -z ${METERIAN_JAR} "https://www.meterian.com/downloads/meterian-cli.jar"  >/dev/null

# launching the client - note the different launch if version requested to preserve the "--version" base functionality
cd /workspace
if [[ -n "${METERIAN_API_TOKEN:-}" || ${METERIAN_CLI_ARGS} == *"--version"* ]];
then
	java -Duser.home=/tmp  -jar ${METERIAN_JAR} ${METERIAN_CLI_ARGS}
fi
# storing exit code
client_exit_code=$?

# dump docker packaged version, and eventually related error messages, right after the client version
if [[ ${METERIAN_CLI_ARGS} == *"--version"* ]];then
    cat /tmp/version.txt        # 0 exit code but it's okay

	exitWithErrorMessageWhenApiTokenIsUnset
fi

exit "$client_exit_code"

# please do not add any command here as we need to preserve the exit status
# of the meterian client
