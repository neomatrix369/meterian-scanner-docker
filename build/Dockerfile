FROM maven:latest

RUN useradd -ms /bin/bash meterian
USER meterian

WORKDIR /home/meterian

ENV HOME=/home/meterian

ENV PATH=${HOME}:${PATH}

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]