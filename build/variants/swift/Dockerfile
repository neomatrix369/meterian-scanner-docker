FROM swift:5.7.3-focal

RUN apt update \
 && apt install -y curl

# install java
RUN apt install -y openjdk-11-jdk

# install ruby
RUN apt install -y ruby2.7 ruby2.7-dev ruby-bundler libffi-dev g++ make

# install cocoapods
RUN gem install cocoapods -v 1.10.2

### Setup initial meterian client (it will be updated if required)
RUN curl -o /tmp/meterian-cli-www.jar -O -J -L https://www.meterian.com/downloads/meterian-cli.jar

### Setup dockerize version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN  echo "© 2017-2021 Meterian Ltd - dockerized version ${VERSION}" > /root/version.txt

### Final entrypoint setup
WORKDIR /root
COPY ./*.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]

### Removing vulnerable components, also they are not used for the purpose of this image
RUN apt-get remove -qy mercurial && apt autoremove -qy --purge