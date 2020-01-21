FROM openjdk:8-jdk

### Variables
ARG DOTNET_VERSION=3.1
ARG MAVEN_VERSION=3.6.3

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils


### Dotnet sdk install
RUN  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
  && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
  && wget -q https://packages.microsoft.com/config/debian/9/prod.list \
  && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
  && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
  && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
  && apt-get update \
  && apt-get -y install dotnet-sdk-${DOTNET_VERSION} \
  && wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb \
  && dpkg -i /tmp/packages-microsoft-prod.deb \
  && rm /tmp/packages-microsoft-prod.deb


### Maven install
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn


## PHP install
RUN apt install -qy apt-transport-https lsb-release ca-certificates \
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
  && apt update \
  && apt -qy install php7.2 \
  && php -v \
  && apt update \
  && apt -qy install php7.2-mbstring \
  && curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php \
  && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && rm /tmp/composer-setup.php \
  && composer --version


## Ruby install
RUN apt-get install -qy ruby2.3 \
  && ruby -v \
  && gem install bundler \
  && bundle -v

  
## Python install
RUN apt-get install -qy python-pip \
  && pip -V \
  && pip install pipenv \
  && pipenv --version


### Node install
RUN apt-get install -qy software-properties-common \
  && curl -sL https://deb.nodesource.com/setup_13.x | bash -\
  && apt-get install -qy nodejs \
  && node -v


## Gradle install
RUN wget -q https://services.gradle.org/distributions/gradle-6.1-bin.zip -P /tmp \
  && unzip -d /opt/gradle /tmp/gradle-*.zip \
  && echo "export GRADLE_HOME=/opt/gradle/gradle-6.1" >> /tmp/gradle.sh \
  && echo "export PATH=\${GRADLE_HOME}/bin:\${PATH}" >> /tmp/gradle.sh \
  && source /tmp/gradle.sh \
  && gradle -v \
  && rm /tmp/gradle* 


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

