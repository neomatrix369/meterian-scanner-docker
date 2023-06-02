# Helper images 'import' for bin copy/installation
FROM rust:1.53.0-alpine3.12 as rustBin

FROM alpine:3.17.2 as binariesStash

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
FROM alpine:3.17.2
COPY ./alpine/util/* /usr/local/bin/


# General setup
RUN apk update \
 && min-apk-add apk-tools>2.10.7-r0 binutils curl>7.77.0-r0 coreutils git openssh \
 && apk upgrade musl


# JAVA install
ARG MAVEN_VERSION=3.8.6-r0
ARG GRADLE_VERSION=8.0.2
ENV PATH=${PATH}:/opt/gradle/gradle-${GRADLE_VERSION}/bin/
RUN min-apk-add openjdk17 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/community \
 && min-apk-add maven=${MAVEN_VERSION} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/community \
 && curl -sSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip --output /tmp/gradle-${GRADLE_VERSION}-all.zip \
 && mkdir -p /opt/gradle; unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-all.zip; rm /tmp/gradle-${GRADLE_VERSION}-all.zip


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
 && rm /tmp/apache-ant-${ANT_VERSION}-bin.tar.gz \
 && ant -version; echo


# DOTNET install
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT="1"
COPY --from=binariesStash /binaries/dotnet/ /usr/lib/dotnet
RUN min-apk-add libstdc++ libintl exiftool \
 && ln -s /usr/lib/dotnet/dotnet /usr/bin/dotnet \
 && source /etc/profile


# PERL (plus carton) install
ARG MOD_PERL2_SHA="890dca0950847e32180485cabbeffbf236af2c92c7df957a233c210022b5172957eddb1db3e9281b87cd438d2fa404a05ae99c7eda098267c68d5e9262b400b0"
RUN min-apk-add perl-dev wget build-base zlib-dev expat-dev libxml2-dev perl-test-harness-utils=3.42-r1 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.12/main \
 # later versions of make don't work with carton for some reason
 && min-apk-add make=4.2.1-r2 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main \
 && min-apk-add ncurses-dev readline-dev perl-net-ssleay openssl gd-dev libjpeg-turbo-dev apr-util-dev=1.6.1-r6 openldap-dev=2.4.58-r0 apache2-dev=2.4.53-r0 mariadb-client --repository=http://dl-cdn.alpinelinux.org/alpine/v3.12/main \
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
ARG RUBY_VERSION=3.1.4-r0
RUN min-apk-add build-base ruby-dev=${RUBY_VERSION} ruby-full=${RUBY_VERSION} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.17/main


# Swift (Cocoapods) install
# Specifically installing due to issue https://github.com/CocoaPods/CocoaPods/issues/10930 affecting v1.11.0
RUN min-apk-add \
 && min-gem-install cocoapods -v 1.10.2


# PHP (Composer) install
RUN min-apk-add php81 php81-phar drupal7 \
 && curl -sS https://getcomposer.org/installer -o composer-setup.php \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm composer-setup.php


# GO install
ENV GOROOT /usr/lib/go
RUN min-apk-add go


# NodeJS (npm) install
RUN min-apk-add yarn \
 && min-apk-add npm=8.1.3-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/main


# SCALA install
ENV PATH=${PATH}:/usr/local/sbt/bin
COPY --from=binariesStash /binaries/scala/ /usr/share/scala/
COPY --from=binariesStash /binaries/sbt/ /usr/local/sbt/
RUN min-apk-add bash --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main \
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
ARG REPOS="--repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/community --repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/main"
RUN min-apk-add python2=2.7.18-r4 python2-dev=2.7.18-r4 python3=3.8.10-r0 python3=3.9.16-r0 python3-dev=3.9.16-r0 zeromq-dev=4.3.4-r0 gdal-dev=3.4.3-r0 libxslt-dev=1.1.35-r0 libxml2-dev=2.9.14-r2 ${REPOS} \
 && min-apk-add g++ openblas-dev=0.3.18-r1 cmake openssl-libs-static openssl-dev ${REPOS} \
 && curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
 && python3 /tmp/get-pip.py \
 && rm /tmp/get-pip.py \
 && min-apk-add linux-headers \
 && min-pip3-install --ignore-installed distlib pipenv pipreqs jupyter


# Conan install
RUN pip3 install conan==1.60.0


# R and renv install
RUN min-apk-add R R-dev \
 && R --slave -e "install.packages('renv', repos='http://cran.r-project.org')" \
 && R --slave -e "packageVersion('renv')"


# Clojure specifics
RUN min-apk-add rlwrap=0.45.2-r1 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.16/community \
 && curl -o /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
 && chmod a+x /usr/local/bin/lein \
 && lein \
 && curl -o /tmp/posix-install-1.11.1.1208.sh https://download.clojure.org/install/posix-install-1.11.1.1208.sh \
 && chmod +x /tmp/posix-install-1.11.1.1208.sh \
 && /tmp/posix-install-1.11.1.1208.sh \
 && rm /tmp/posix-install-1.11.1.1208.sh


# Adding shadow to allow the meterian user creation with uid/gid matching host see https://github.com/MeterianHQ/meterian-scanner-docker/issues/19
RUN min-apk-add shadow


# Meterian client Download
RUN wget -q -O /tmp/meterian-cli-www.jar https://www.meterian.com/downloads/meterian-cli.jar


### Setup dockerized version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN echo "" >> /root/version.txt
RUN echo "© 2017-2022 Meterian Ltd - dockerized version ${VERSION}" >> /root/version.txt


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]
