FROM alpine:3.12
COPY ./alpine/util/* /usr/local/bin/


# General setup
RUN apk update \
 && min-apk-add binutils curl coreutils


# JAVA install
RUN min-apk-add openjdk11


# Python install
RUN min-apk-add libstdc++ python3 py3-pip python3-dev python2 libffi-dev python2-dev zeromq-dev gdal-dev \
 && min-apk-add g++ zlib-dev openblas-dev cmake openssl-libs-static openssl-dev

# Conan install
RUN pip3 install conan

# Adding shadow to allow the meterian user creation with uid/gid matching host see https://github.com/MeterianHQ/meterian-scanner-docker/issues/19
RUN min-apk-add shadow \
 && min-apk-add bash=5.0.17-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main


# Meterian client Download
RUN wget -q -O /tmp/meterian-cli-www.jar https://www.meterian.com/downloads/meterian-cli.jar


### Setup dockerized version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN echo "" >> /root/version.txt
RUN echo "© 2017-2021 Meterian Ltd - dockerized version ${VERSION}" >> /root/version.txt


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]
