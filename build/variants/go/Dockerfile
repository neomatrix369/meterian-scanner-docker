FROM openjdk:8-jdk

### Variables
ARG GO_VERSION=1.14.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils


## Go install
ENV GOROOT /usr/local/go
ENV PATH $GOROOT/bin:$PATH
RUN wget -q https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -P /tmp \
  && tar -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local \
  && go version \
  && rm -f /tmp/go${GO_VERSION}*


### Setup initial meterian client (it will be updated if required)
RUN curl -o /meterian-cli.jar -O -J -L https://www.meterian.com/downloads/meterian-cli.jar


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

