#!/bin/bash

METERIAN_HOME="/home/meterian/"
mkdir -p ${METERIAN_HOME}

if [[ -f ${HOME}/.gitconfig ]]; then
    cp ${HOME}/.gitconfig ${METERIAN_HOME}
fi

if [[ -d ${HOME}/.ssh ]]; then
   cp -R ${HOME}/.ssh ${METERIAN_HOME}
fi

if [[ -f ${METERIAN_HOME}.ssh/config ]]; then
    sed -i 's/IdentityFile.*\.ssh/IdentityFile \/home\/meterian\/.ssh/g' ${METERIAN_HOME}.ssh/config
fi

sed -i 's/chown/chown -R/g' /root/entrypoint.sh
/root/entrypoint.sh $*