#!/bin/bash

# executing general initialisation script
#cat /tmp/init.sh
source /tmp/init.sh

exitWithErrorMessageWhenApiTokenIsUnset() {
	if [[ -z "${METERIAN_API_TOKEN:-}" ]] 
	then
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo " The METERIAN_API_TOKEN environment variable must be defined with an API token   "
		echo
		echo " Please create a token from your account at https://meterian.com/account/#tokens "
		echo " and populate the variable with the value of the token "
		echo
		echo " For example: "
		echo " export METERIAN_API_TOKEN=12345678-90ab-cdef-1234-567890abcdef "
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-"
		exit -1
	fi
}

updateClient() {
	METERIAN_JAR_PATH=$1
	CLIENT_TARGET_URL=$2

	LOCAL_CLIENT_LAST_MODIFIED_DATE=$(date -d "$(ls --full-time ${METERIAN_JAR_PATH} | cut -d" " -f6-8)" +%F)
	REMOTE_CLIENT_LAST_MODIFIED_DATE=$(date -d "$(curl -s -L -I "${CLIENT_TARGET_URL}" \
									| grep Last-Modified: | cut -d" " -f2-)" +%F)
	if [[ "${REMOTE_CLIENT_LAST_MODIFIED_DATE}" > "${LOCAL_CLIENT_LAST_MODIFIED_DATE}" ]];
	then
		echo Updating the client$(test -n "${CLIENT_CANARY_FLAG}" && echo " canary" || true)...
		curl -s -o ${METERIAN_JAR_PATH} "${CLIENT_TARGET_URL}"  >/dev/null
	fi
}

INDEPENDENT_METERIAN_CLI_OPTIONS="(--version|--help)"

# dump docker packaged version unless '--version' requested
if [[ ! ${METERIAN_CLI_ARGS} =~ ${INDEPENDENT_METERIAN_CLI_OPTIONS} ]]; then
    cat /tmp/version.txt
	exitWithErrorMessageWhenApiTokenIsUnset
fi

# meterian jar location
METERIAN_JAR=/tmp/meterian-cli.jar

# download canary client if flag is set
if [[ -n ${CLIENT_CANARY_FLAG}  ]];
then
	METERIAN_JAR=/tmp/meterian-cli-canary.jar
	# download cli-canary if it does not exist 
	if [[ ! -f ${METERIAN_JAR} ]];
	then
		echo Downloading client canary...	
		curl -s -o ${METERIAN_JAR} "https://www.meterian.io/downloads/meterian-cli-canary.jar"  >/dev/null
	else
		# update cli-canary if necessary
		updateClient "${METERIAN_JAR}" "https://www.meterian.io/downloads/meterian-cli-canary.jar"
	fi
	
else
	# update the client if necessary
	if [[ ! -f ${METERIAN_JAR} ]];
	then
		mv /meterian-cli.jar /tmp/
	fi

	updateClient "${METERIAN_JAR}" "https://www.meterian.com/downloads/meterian-cli.jar"
fi

# launching the client - note the different launch if version requested to preserve the "--version" base functionality
cd /workspace
if [[ -n "${METERIAN_API_TOKEN:-}" || ${METERIAN_CLI_ARGS} =~ ${INDEPENDENT_METERIAN_CLI_OPTIONS} ]];
then
	java -Duser.home=/tmp ${CLIENT_VM_PARAMS} -jar ${METERIAN_JAR} ${METERIAN_CLI_ARGS} --interactive=false
fi
# storing exit code
client_exit_code=$?

# dump docker packaged version, and eventually related error messages, right after the client version
if [[ ${METERIAN_CLI_ARGS} =~ ${INDEPENDENT_METERIAN_CLI_OPTIONS} ]];then
    cat /tmp/version.txt        # 0 exit code but it's okay

	exitWithErrorMessageWhenApiTokenIsUnset
fi

exit "$client_exit_code"

# please do not add any command here as we need to preserve the exit status
# of the meterian client
