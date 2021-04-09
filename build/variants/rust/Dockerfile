FROM openjdk:11.0.10-jdk-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils


### Rust install
RUN curl https://sh.rustup.rs -sSf | env RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo sh -s -- --default-toolchain stable --profile default --no-modify-path -y


### Setup initial meterian client (it will be updated if required)
RUN curl -o /tmp/meterian-cli-www.jar -O -J -L https://www.meterian.com/downloads/meterian-cli.jar


### Setup dockerize version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN echo "" >> /root/version.txt
RUN echo "© 2017-2020 Meterian Ltd - dockerized version ${VERSION}" >> /root/version.txt


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]


### Removing vulnerable components, also they are not used for the purpose of this image
RUN apt-get remove -qy mercurial wget