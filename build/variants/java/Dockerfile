# Helper images 'import' for bin copy/installation
FROM alpine:3.12 as binariesStash

ARG SCALA_VERSION=2.13.6
ARG SBT_VERSION=1.5.3

WORKDIR /binaries/

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
 && min-apk-add binutils curl coreutils git openssh \
 && apk upgrade musl


# JAVA install
ARG MAVEN_VERSION=3.6.3-r0
ARG GRADLE_VERSION=8.0.2
ENV PATH=${PATH}:/opt/gradle/gradle-${GRADLE_VERSION}/bin/
RUN min-apk-add openjdk17 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/community \
 && min-apk-add maven=${MAVEN_VERSION} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/community \
 && curl -sSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip --output /tmp/gradle-${GRADLE_VERSION}-all.zip \
 && mkdir -p /opt/gradle; unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-all.zip; rm /tmp/gradle-${GRADLE_VERSION}-all.zip


# SCALA install
ENV PATH=${PATH}:/usr/local/sbt/bin
COPY --from=binariesStash /binaries/scala/ /usr/share/scala/
COPY --from=binariesStash /binaries/sbt/ /usr/local/sbt/
# installing min version supported of bash only for scala and sbt that require it
RUN min-apk-add bash=5.0.17-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main \
 && ln -s /usr/share/scala/bin/scala /usr/bin/scala 


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
RUN echo "© 2017-2021 Meterian Ltd - dockerized version ${VERSION}" >> /root/version.txt


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]
