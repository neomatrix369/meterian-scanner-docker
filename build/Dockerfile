FROM maven:3.6.1-jdk-13

RUN groupadd -r meterian \
    && useradd -s /bin/false \
               -g meterian meterian

ARG METERIAN_HOME
WORKDIR ${METERIAN_HOME}
ENV METERIAN_HOME=${METERIAN_HOME}
ENV PATH=${METERIAN_HOME}:${PATH}

COPY entrypoint.sh entrypoint.sh

RUN chown -R meterian:meterian ${METERIAN_HOME}

USER meterian

ENTRYPOINT ["entrypoint.sh"]