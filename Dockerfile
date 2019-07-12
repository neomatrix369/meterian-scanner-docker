FROM maven:latest

WORKDIR /home/

RUN echo "~~~~~~ Downloading the latest version of the Meterian Scanner client" && \
    mkdir -p ${WORK_DIR}/.meterian/ && \
    curl -o ${WORK_DIR}/.meterian/meterian-cli.jar -O -J -L \
         https://www.meterian.com/latest-client-canary

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]