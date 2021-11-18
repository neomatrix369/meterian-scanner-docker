FROM openjdk:11.0.12-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils curl git openssh


## Python install
RUN apt install -qy build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev \
  && pushd /tmp; curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz \
  && tar -xf Python-3.8.2.tar.xz \
  && cd Python-3.8.2 \
  && ./configure --enable-optimizations \
  && make -j $(nproc) \
  && make install \
  && popd; echo -ne "\n$(python3 --version)\n" \
  && apt-get install -qy python3-pip \
  && pip3 install --upgrade pip \
  && echo -ne "\n$(pip3 --version)\n" \
  && pip3 install jupyter pipreqs pipenv \
  && apt-get install -qy python-pip \
  && echo -ne "\n$(pip --version)\n" \
  && rm -rf /tmp/Python-3.8.2


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