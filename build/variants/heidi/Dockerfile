FROM meterian/cli:latest

RUN pip3 uninstall pipenv virtualenv --yes \
 && min-pip3-install --ignore-installed pipenv==2022.8.5 virtualenv==20.16.3

ENTRYPOINT ["/root/entrypoint.sh"]
