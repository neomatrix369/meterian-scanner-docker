FROM maven:latest

WORKDIR /home/

COPY .  /home/

ARG METERIAN_API_TOKEN
ENV METERIAN_API_TOKEN=${METERIAN_API_TOKEN}

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]