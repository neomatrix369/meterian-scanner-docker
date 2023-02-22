FROM meterian/cli:latest

RUN curl -sSL "https://raw.githubusercontent.com/MeterianHQ/meterian-pr/main/requirements.txt" -o /tmp/requirements.txt
RUN pip3 install --ignore-installed -r /tmp/requirements.txt

RUN mkdir -p /usr/share/meterian-pr; git clone https://github.com/MeterianHQ/meterian-pr.git /usr/share/meterian-pr/

COPY ./variants/gha/meterian-pr /usr/bin/meterian-pr

ENTRYPOINT ["/root/entrypoint.sh"]