FROM openjdk:17.0.2-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


### General setup
RUN  apt-get update \
  && apt-get -y install apt-transport-https apt-utils curl git


## R and renv install
RUN apt install -qy gnupg2 libcurl4-openssl-dev libssl-dev \
 && echo -ne "# R repository\ndeb http://cloud.r-project.org/bin/linux/debian buster-cran35/\n" >>  /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' \
 && apt update && apt install -qy r-base \
 && R --slave -e "install.packages('renv', repos='http://cran.r-project.org')" \
 && R --slave -e "packageVersion('renv')"


### Setup initial meterian client (it will be updated if required)
RUN curl -o /tmp/meterian-cli-www.jar -O -J -L https://www.meterian.com/downloads/meterian-cli.jar


### Setup dockerize version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN  echo "© 2017-2022 Meterian Ltd - dockerized version ${VERSION}" > /root/version.txt


### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]


### Removing vulnerable components, also they are not used for the purpose of this image
RUN apt-get remove -qy mercurial wget && apt autoremove -qy --purge