FROM meterian/cli:latest

RUN pip3 install --ignore-installed PyGithub==1.55

# Meterian-pr tool installation
ENV PATH=${PATH}:/usr/local/meterian-pr/bin
RUN wget -O /tmp/meterian-pr_alpine-linux.tar.gz -q https://github.com/MeterianHQ/meterian-pr/releases/download/1.1.6/meterian-pr_alpine-linux.tar.gz \
 && mkdir -p /usr/local/meterian-pr \
 && tar -xzf /tmp/meterian-pr_alpine-linux.tar.gz -C /usr/local/meterian-pr \
 && rm /tmp/meterian-pr_alpine-linux.tar.gz \
 && meterian-pr --version

ENTRYPOINT ["/root/entrypoint.sh"]