# Helper images 'import' for bin copy/installation
FROM rust:1.53.0-alpine3.12 as rustBin

FROM alpine:3.12 as binariesStash

ARG DOTNET_VERSION=3.1.410
ARG DOTNET_DOWNLOAD_SHA="d844e044d7dfbca0b69913c3d5a5dde0f46ddf4a43c1e8c2a474dc65c3089521d0e946507ede4654efc4281314360c66f5c477ee90e1e80f30115e7a5aa1b586"

ARG SCALA_VERSION=2.13.6
ARG SBT_VERSION=1.5.3

WORKDIR /binaries/

# DOTNET bin
RUN mkdir -p dotnet \
 && wget -q "https://download.visualstudio.microsoft.com/download/pr/7212036d-2481-4cb3-87d3-b559a21f0c34/1953e788344059b0c279879b2ba559e7/dotnet-sdk-${DOTNET_VERSION}-linux-musl-x64.tar.gz"
## Here it's important to keep two spaces between the sha and the download to match sha512sum output
RUN echo "${DOTNET_DOWNLOAD_SHA}  /binaries/dotnet-sdk-${DOTNET_VERSION}-linux-musl-x64.tar.gz" | sha512sum -c -
RUN tar -xzf dotnet-sdk-${DOTNET_VERSION}-linux-musl-x64.tar.gz -C dotnet

# SCALA bin
RUN mkdir -p scala sbt \
 && apk --no-cache add curl \
 && curl -sS https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz -o scala-${SCALA_VERSION}.tgz \
 && tar xzf scala-${SCALA_VERSION}.tgz -C scala --strip-components=1
RUN wget -q https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz
RUN tar xzf sbt-${SBT_VERSION}.tgz -C sbt --strip-components=1




# Final image build steps
FROM alpine:3.12
COPY ./alpine/util/* /usr/local/bin/


# General setup
RUN apk update \
 && min-apk-add apk-tools>2.10.7-r0 binutils curl>7.77.0-r0 coreutils git openssh \
 && apk upgrade musl


# JAVA install
ARG MAVEN_VERSION=3.6.3-r0
ARG GRADLE_VERSION=6.7.1-r0
RUN min-apk-add openjdk11 maven=${MAVEN_VERSION} \
 && min-apk-add gradle=${GRADLE_VERSION} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/community

# Ant specifics
ENV ANT_HOME=/usr/share/ant
ENV PATH=${PATH}:${ANT_HOME}/bin
ARG ANT_VERSION=1.10.12
ARG IVY_VERSION=2.5.0
RUN wget -q -O /tmp/apache-ant-${ANT_VERSION}-bin.tar.gz https://dlcdn.apache.org//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
 && mkdir -p /usr/share/ant \
 && tar xzf /tmp/apache-ant-${ANT_VERSION}-bin.tar.gz -C /usr/share/ant --strip-components=1 \
 && wget -q -O ${ANT_HOME}/lib/ivy.jar https://repo1.maven.org/maven2/org/apache/ivy/ivy/${IVY_VERSION}/ivy-${IVY_VERSION}.jar \
 && ln -s /usr/share/ant/bin/ant /usr/bin/ant \
 && ant -version; echo


# DOTNET install
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT="1"
COPY --from=binariesStash /binaries/dotnet/ /usr/lib/dotnet
RUN min-apk-add libstdc++ libintl \
 && ln -s /usr/lib/dotnet/dotnet /usr/bin/dotnet \
 && source /etc/profile


# PERL (plus carton) install
ARG MOD_PERL2_SHA="890dca0950847e32180485cabbeffbf236af2c92c7df957a233c210022b5172957eddb1db3e9281b87cd438d2fa404a05ae99c7eda098267c68d5e9262b400b0"
RUN min-apk-add perl-dev wget zlib-dev expat-dev libxml2-dev perl-test-harness-utils \
 # later versions of make don't work with carton for some reason
 && min-apk-add make=4.2.1-r2 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main \
 && min-apk-add ncurses-dev readline-dev perl-net-ssleay openssl gd-dev libjpeg-turbo-dev apache2-dev mariadb-client \
 # mod_perl2 module installation (https://perl.apache.org/download/)
 && wget -q -O /tmp/mod_perl-2.0.12.tar.gz https://dlcdn.apache.org/perl/mod_perl-2.0.12.tar.gz \
 && echo "${MOD_PERL2_SHA}  /tmp/mod_perl-2.0.12.tar.gz" | sha512sum -c - \
 && tar -xvzf /tmp/mod_perl-2.0.12.tar.gz -C /tmp > /dev/null 2>&1 \
 && PREV_DIR=$(pwd); cd /tmp/mod_perl-2.0.12 \
 && perl Makefile.PL > /dev/null 2>&1 \
 && make > /dev/null 2>&1 \
 && make install > /dev/null 2>&1 \
 && cd $PREV_DIR; rm -rf /tmp/mod_perl-2.0.12.tar.gz /tmp/mod_perl-2.0.12 \
 # carton and cpanm installations
 && curl -L https://cpanmin.us | perl - App::cpanminus \
 && cpanm -n -q Carton App::cpm \
 && rm -rf ~/.cpanm


# Ruby install
ARG RUBY_VERSION=2.7.5-r0
RUN min-apk-add build-base ruby-dev=${RUBY_VERSION} ruby-full=${RUBY_VERSION}


# Swift (Cocoapods) install
# Specifically installing due to issue https://github.com/CocoaPods/CocoaPods/issues/10930 affecting v1.11.0
RUN min-apk-add \
 && min-gem-install cocoapods -v 1.10.2


# PHP (Composer) install
RUN min-apk-add php7 php-json php-phar php-iconv php-openssl --repository=http://dl-cdn.alpinelinux.org/alpine/v3.12/main \
 && curl -sS https://getcomposer.org/installer -o composer-setup.php \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm composer-setup.php


# GO install
ENV GOROOT /usr/lib/go
RUN min-apk-add go --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community


# NodeJS (npm) install
RUN min-apk-add npm


# SCALA install
ENV PATH=${PATH}:/usr/local/sbt/bin
COPY --from=binariesStash /binaries/scala/ /usr/share/scala/
COPY --from=binariesStash /binaries/sbt/ /usr/local/sbt/
# installing min version possible of bash only for scala and sbt that require it
RUN min-apk-add bash=5.0.17-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main \
 && ln -s /usr/share/scala/bin/scala /usr/bin/scala


# Rust install
ENV PATH=${PATH}:/opt/rust/cargo/bin \
    RUSTUP_HOME=/opt/rust/rustup
COPY --from=rustBin /usr/local/cargo/ /opt/rust/cargo
COPY --from=rustBin /usr/local/rustup/toolchains/1.53.0-x86_64-unknown-linux-musl/bin/cargo /opt/rust/rustup/toolchains/1.53.0-x86_64-unknown-linux-musl/bin/cargo
# install the standard toolchain for the current arch in minimal profile (as of now this installs cargo, rust-std & rustc) and remove rust-std
RUN rustup set profile minimal \
 && rustup toolchain install stable || true \
 && rustup component remove rust-std


# Python install
RUN min-apk-add python3 py3-pip python3-dev python2 libffi-dev python2-dev zeromq-dev gdal-dev \
 && min-apk-add g++ zlib-dev openblas-dev cmake openssl-libs-static openssl-dev \
 && min-pip3-install --ignore-installed distlib pipenv pipreqs jupyter setuptools


# Conan install
RUN pip3 install conan


# Adding shadow to allow the meterian user creation with uid/gid matching host see https://github.com/MeterianHQ/meterian-scanner-docker/issues/19
RUN min-apk-add shadow


# Meterian client Download
RUN wget -q -O /tmp/meterian-cli-www.jar https://www.meterian.com/downloads/meterian-cli.jar


### Setup dockerized version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN echo "" >> /root/version.txt
RUN echo "© 2017-2021 Meterian Ltd - dockerized version ${VERSION}" >> /root/version.txt

# Vuln patches
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/main" >> /etc/apk/repositories \
 && apk update \
 && min-apk-add -u libbsd=0.11.3-r0 \
 && min-apk-add -u libx11=1.7.2-r0


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]
