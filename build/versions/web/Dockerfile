FROM openjdk:8-jdk

### Variables
ARG PHP_VERSION=7.2
ARG NODE_VERSION=13.x

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils


## PHP install
RUN apt install -qy apt-transport-https lsb-release ca-certificates \
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
  && apt update \
  && apt -qy install php${PHP_VERSION} \
  && php -v \
  && apt update \
  && apt -qy install php${PHP_VERSION}-mbstring \
  && curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php \
  && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && rm /tmp/composer-setup.php \
  && composer --version


### Node install
RUN apt-get install -qy software-properties-common \
  && curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -\
  && apt-get install -qy nodejs \
  && node -v


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

