FROM openjdk:8-jdk

### Gebnral setup
RUN echo $(cat /etc/issue)
RUN apt-get update
RUN apt-get -y install apt-transport-https apt-utils

### Dotnet - Register Microsoft key and feed
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
 && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
 && wget -q https://packages.microsoft.com/config/debian/9/prod.list \
 && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
 && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
 && chown root:root /etc/apt/sources.list.d/microsoft-prod.list

### Dotnet - Install the .NET Core SDK
RUN apt-get update \
 && apt-get -y install dotnet-sdk-3.1

RUN wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
RUN dpkg -i /tmp/packages-microsoft-prod.deb
RUN rm /tmp/packages-microsoft-prod.deb

### Install Maven
ARG MAVEN_VERSION=3.6.3
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ARG METERIAN_HOME
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "${METERIAN_HOME}/.m2"
ENV PATH=${MAVEN_HOME}/bin:${PATH}

RUN mvn -version

### These components are vulnerable as per the scanner, also they are not used for the purpose of this image, hence being removed
RUN apt-get remove -qy mercurial python2.7 wget

## Meterian setup
RUN groupadd -r meterian \
    && useradd -r -s /bin/false \
               -g meterian meterian

WORKDIR ${METERIAN_HOME}
ENV METERIAN_HOME=${METERIAN_HOME}
ENV PATH=${METERIAN_HOME}:${PATH}

COPY entrypoint.sh entrypoint.sh

RUN chown -R meterian:meterian ${METERIAN_HOME}

USER meterian

ENTRYPOINT ["entrypoint.sh"]
