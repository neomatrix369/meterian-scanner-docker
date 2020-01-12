#!/bin/bash

set -e
set -o pipefail

# prepare the script file
mv /root/meterian.sh /tmp/meterian.sh
mv /root/version.txt /tmp/version.txt

# run the script binding the user if required
if [ "${HOST_UID}" == "" ];
then
    export XPATH=$PATH
    /tmp/meterian.sh $*

    # please do not add any command here as we need to preserve the exit status
    # of the meterian client
else
    # create the user
    echo UID: ${HOST_UID}
    useradd -u ${HOST_UID} meterian -d /home/meterian

    # launch meterian client with the newly created user
    export XPATH=$PATH
    su meterian -c -m /tmp/meterian.sh $* 2>/dev/null

    # please do not add any command here as we need to preserve the exit status
    # of the meterian client
fi

# please do not add any command here as we need to preserve the exit status
# of the meterian client
