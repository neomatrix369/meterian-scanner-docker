#!/bin/bash

set -e
set -o pipefail

# prepare the script file
mv /root/meterian.sh /tmp/meterian.sh
mv /root/version.txt /tmp/version.txt
export METERIAN_CLI_ARGS=$*

# create initialisation script (gradle)
echo "export PATH=${PATH}" >> /tmp/init.sh

# - add gradle specific configurations
echo "export GRADLE_HOME=/opt/gradle/gradle-6.1" >> /tmp/init.sh
echo "export PATH=\${GRADLE_HOME}/bin:\${PATH}" >> /tmp/init.sh
echo "export GRADLE_USER_HOME=~/.gradle" >> /tmp/init.sh

# - add go specific configurations
echo "export GOROOT=/usr/local/go" >> /tmp/init.sh
echo "export PATH=\${GOROOT}/bin:\${PATH}" >> /tmp/init.sh

# prepare command options with the host uid and gid when present
WITH_HUID=""
WITH_HGID=""
if [ -n "${HOST_UID}" ];
then
    WITH_HGID="-g ${HOST_GID} -o"
    WITH_HUID="-ou ${HOST_UID}"
fi

# create the user
groupadd ${WITH_HGID} meterian
useradd -g meterian ${WITH_HUID} meterian -d /home/meterian

# creating home dir if it doesn't exist
if [ ! -d "/home/meterian" ];
then
    mkdir /home/meterian
fi

#changing home dir group and ownership
chown meterian:meterian /home/meterian

# launch meterian client with the newly created user
su meterian -c -m /tmp/meterian.sh  2>/dev/null

# please do not add any command here as we need to preserve the exit status
# of the meterian client

# please do not add any command here as we need to preserve the exit status
# of the meterian client
