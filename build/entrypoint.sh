#!/bin/bash

set -e
set -u
set -o pipefail

# debugging users
# echo "Host uid: ${HOST_UID}"
# echo "Host gid: ${HOST_GID}"

# create the user
groupadd -g ${HOST_GID} meterian
useradd -g meterian -u ${HOST_UID} meterian -d /home/meterian
# grep meterian /etc/passwd

# prepare the script file
mv /root/meterian.sh /tmp/meterian.sh
mv /root/version.txt /tmp/version.txt
chmod +x /tmp/meterian.sh

# launch meterian client with the newly created user
export XPATH=$PATH
su meterian -c -m /tmp/meterian.sh $* 2>/dev/null
