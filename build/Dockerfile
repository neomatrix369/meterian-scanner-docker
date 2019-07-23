FROM openjdk:8-jdk

RUN apt-get remove -qy mercurial python2.7 wget

### Install Maven
ARG MAVEN_VERSION=3.6.1
ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

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