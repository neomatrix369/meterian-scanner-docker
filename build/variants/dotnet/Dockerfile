# Helper images 'import' for bin copy/installation
FROM alpine:3.12 as binariesStash

ARG DOTNET_VERSION=3.1.426
ARG DOTNET_DOWNLOAD_SHA="2854eaeb79b29fce1ae31f2253adb2d8f199b7d5a988fc8c90130afe3df6668893d87c14a86932254bdbaec64a553d7b996bbd6868ba7858e3a2cb28c5e9576d"

WORKDIR /binaries/

# DOTNET bin
RUN mkdir -p dotnet \
 && wget -q "https://download.visualstudio.microsoft.com/download/pr/f8834fef-d2ab-4cf6-abc3-d8d79cfcde11/0ee05ef4af5fe324ce2977021bf9f340/dotnet-sdk-${DOTNET_VERSION}-linux-musl-x64.tar.gz"
## Here it's important to keep two spaces between the sha and the download to match sha512sum output
RUN echo "${DOTNET_DOWNLOAD_SHA}  /binaries/dotnet-sdk-${DOTNET_VERSION}-linux-musl-x64.tar.gz" | sha512sum -c -
RUN tar -xzf dotnet-sdk-${DOTNET_VERSION}-linux-musl-x64.tar.gz -C dotnet




# Final image build steps
FROM alpine:3.12
COPY ./alpine/util/* /usr/local/bin/


# General setup
RUN apk update \
 && min-apk-add binutils curl coreutils git openssh \
 && apk upgrade musl


# JAVA install
RUN min-apk-add openjdk17 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/community


# DOTNET install
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT="1"
COPY --from=binariesStash /binaries/dotnet/ /usr/lib/dotnet
RUN min-apk-add libstdc++ libintl exiftool \
 && ln -s /usr/lib/dotnet/dotnet /usr/bin/dotnet \
 && source /etc/profile


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
