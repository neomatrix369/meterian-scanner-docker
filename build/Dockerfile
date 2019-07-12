FROM maven:latest

RUN useradd -ms /bin/bash meterian
USER meterian

WORKDIR /home/meterian

ENV HOME=/home/meterian

RUN echo "~~~~~~ Downloading the latest version of the Meterian Scanner client" && \
    mkdir -p ${HOME}/.meterian/ && \
    curl -o ${HOME}/.meterian/meterian-cli.jar -O -J -L \
         https://www.meterian.com/latest-client-canary

ENV PATH=${HOME}:${PATH}

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]