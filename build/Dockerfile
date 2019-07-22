FROM maven:3.6.1-jdk-13

RUN useradd -ms /bin/bash meterian
USER meterian

WORKDIR /home/meterian

ENV HOME=/home/meterian

ENV PATH=${HOME}:${PATH}

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]