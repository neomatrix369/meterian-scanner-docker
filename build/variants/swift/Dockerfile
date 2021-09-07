FROM openjdk:11.0.10-jdk-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils


## Swift install
RUN apt-get install -qy ruby ruby-dev build-essential\
  && ruby -v \
  && gem install cocoapods -v 1.10.2 \
  && gem which cocoapods | grep -oh cocoapods-[0-9\.]* \
  && apt-get remove -qy build-essential \
  && apt -qy autoremove


### Setup initial meterian client (it will be updated if required)
RUN curl -o /tmp/meterian-cli.jar -O -J -L https://www.meterian.com/downloads/meterian-cli.jar


### Setup dockerize version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN  echo "© 2017-2020 Meterian Ltd - dockerized version ${VERSION}" > /root/version.txt


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]


### Removing vulnerable components, also they are not used for the purpose of this image
RUN apt-get remove -qy mercurial python2.7 wget

