FROM openjdk:17.0.2-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils curl git


## Python install
RUN apt install -qy build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev

RUN apt install -qy python2 python2-dev
RUN ln -s /usr/bin/python2.7 /usr/bin/python

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py
RUN python2 /tmp/get-pip.py
RUN echo -ne "\n$(pip2 --version)\n"

RUN pip install pipreqs pipenv
RUN apt install -qy jupyter
RUN mv /usr/bin/jupyter /usr/bin/jupyter-cli
COPY ./python-specific/python2/jupyter /usr/bin/


### Setup initial meterian client (it will be updated if required)
RUN curl -o /tmp/meterian-cli-www.jar -O -J -L https://www.meterian.com/downloads/meterian-cli.jar


### Setup dockerize version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN  echo "© 2017-2021 Meterian Ltd - dockerized version ${VERSION}" > /root/version.txt


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]


### Removing vulnerable components, also they are not used for the purpose of this image
RUN apt-get remove -qy mercurial wget && apt autoremove -qy --purge