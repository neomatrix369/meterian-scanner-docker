#!/bin/bash

set -e

VERSION="${1:-}"
if [[ -z "$VERSION" ]];then
    VERSION=master
fi

curl -sS https://raw.githubusercontent.com/MeterianHQ/meterian-github-action/$VERSION/entrypoint.sh -o /root/entrypoint.sh
curl -sS https://raw.githubusercontent.com/MeterianHQ/meterian-github-action/$VERSION/meterian.sh -o /root/meterian.sh

currDir=$(pwd)
THE_UID="$(stat -c '%u' "${currDir}")"
THE_GID="$(stat -c '%g' "${currDir}")"
chown -R $THE_UID:$THE_GID .

/root/entrypoint.sh