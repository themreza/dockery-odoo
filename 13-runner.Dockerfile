FROM registry.gitlab.com/xoe/odoo/odoo-docker-base:base

ENV RANCHER_CLI_VERSION v0.6.2

# Get secondary binaries and pythonscripts by default
ONBUILD COPY .docker/bin/*           /usr/local/bin/
ONBUILD COPY .docker/lib/*           /usr/local/lib/python2.7/dist-packages/odoo-docker-base-libs/
# Get secondary entrypoint scripts and config files
ONBUILD COPY .docker/entrypoint.d/*  /home/entrypoint.d/
ONBUILD COPY .docker/config.d/*      /home/config.d/
# Set executing bit on freshly added files, also
ONBUILD RUN chmod +x -R /home /usr/local/bin/ /usr/local/lib/python2.7/dist-packages/
# Automate secondary build steps in one single step
ONBUILD COPY .docker/build.d         /home/build.d
ONBUILD RUN ln /usr/local/bin/build-dir-exec.sh /usr/local/bin/build.sh
ONBUILD RUN chmod +x /home/build.d/*.sh && build.sh

# python and odoo linting setup
RUN pip install --upgrade --pre pylint-odoo
RUN pip install pylint-mccabe coverage

# docker, ssh, git, rancher-cli
RUN apt-get update && apt-get install -y --no-install-recommends \
        git-all \
        openssh-client
RUN curl -sSL https://get.docker.com/ | sh > /dev/null
RUN curl -L "https://github.com/docker/compose/releases/download/1.14.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  > /dev/null
RUN chmod +x /usr/local/bin/docker-compose
RUN wget -O /tmp/rancher-cli.tar.gz https://github.com/rancher/cli/releases/download/${RANCHER_CLI_VERSION}/rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz
RUN tar -zxf /tmp/rancher-cli.tar.gz -C /tmp
RUN chmod +x /tmp/rancher-${RANCHER_CLI_VERSION} && cp /tmp/rancher-${RANCHER_CLI_VERSION}/rancher /usr/local/bin/

# Some pip libraries for interacting with apis
RUN pip install click hammock odoorpc

ENTRYPOINT []
CMD []
