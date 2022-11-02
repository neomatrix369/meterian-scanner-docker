FROM meterian/cli:latest

RUN pip3 uninstall pipenv virtualenv --yes \
 && min-pip3-install --ignore-installed pipenv==2022.8.5 virtualenv==20.16.3

### Setup dockerized version stamp
ARG VERSION
RUN test -n "${VERSION}"
RUN echo "" > /root/version.txt
RUN echo "© 2017-2022 Meterian Ltd - dockerized version ${VERSION}" >> /root/version.txt

ENTRYPOINT ["/root/entrypoint.sh"]
