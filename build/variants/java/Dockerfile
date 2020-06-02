FROM openjdk:11.0.10-jdk-buster

### Variables
ARG MAVEN_VERSION=3.6.3
ARG GRADLE_VERSION=6.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils


### Maven install
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn


## Gradle install
ENV GRADLE_USER_HOME ~/.gradle
ENV GRADLE_HOME /opt/gradle/gradle-${GRADLE_VERSION}
ENV PATH $GRADLE_HOME/bin:$PATH
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
  && unzip -d /opt/gradle /tmp/gradle-*.zip \
  && gradle -v \
  && rm /tmp/gradle* 


## Scala install
RUN apt-get install -qy scala \
  && scala -version \
  && echo "deb https://dl.bintray.com/sbt/debian /" >> /etc/apt/sources.list.d/sbt.list \
  && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add \
  && apt-get update \
  && apt-get install -qy sbt


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

