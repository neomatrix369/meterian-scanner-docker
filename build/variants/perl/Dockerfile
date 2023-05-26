FROM alpine:3.12
COPY ./alpine/util/* /usr/local/bin/


# General setup
RUN apk update \
 && min-apk-add binutils curl coreutils git openssh \
 && apk upgrade musl


# JAVA install
RUN min-apk-add openjdk17 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/community


# PERL (plus carton) install
ARG MOD_PERL2_SHA="890dca0950847e32180485cabbeffbf236af2c92c7df957a233c210022b5172957eddb1db3e9281b87cd438d2fa404a05ae99c7eda098267c68d5e9262b400b0"
RUN min-apk-add perl-dev wget build-base zlib-dev libressl-dev expat-dev libxml2-dev perl-test-harness-utils \
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
