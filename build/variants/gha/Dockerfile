FROM meterian/cli:latest

RUN pip3 install --ignore-installed PyGithub==1.55

# Meterian-pr tool installation
ARG TOOL_VERSION=1.1.7
ENV PATH=${PATH}:/usr/local/meterian-pr/bin
RUN wget -O /tmp/meterian-pr_alpine-linux.tar.gz -q https://github.com/MeterianHQ/meterian-pr/releases/download/${TOOL_VERSION}/meterian-pr_alpine-linux.tar.gz \
 && mkdir -p /usr/local/meterian-pr \
 && tar -xzf /tmp/meterian-pr_alpine-linux.tar.gz -C /usr/local/meterian-pr \
 && rm /tmp/meterian-pr_alpine-linux.tar.gz \
 && meterian-pr --version

ENTRYPOINT ["/root/entrypoint.sh"]