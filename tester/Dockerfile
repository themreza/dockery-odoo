ARG  FROM_IMAGE=xoes/dockery-odoo
FROM ${FROM_IMAGE}

USER root
# python and odoo linting setup
RUN pip install --upgrade --pre pylint-odoo
RUN pip install pylint-mccabe coverage

# Some git tools for standard diffing
RUN apt-get update && apt-get install -y --no-install-recommends git-core

ENV GOSU_VERSION 1.10
RUN wget https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }') && \
	mv gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }') /usr/local/bin/gosu && \
	chmod +x /usr/local/bin/gosu 

COPY bin/* /usr/local/bin/
COPY entrypoint.d/* /entrypoint.d/
COPY lib/* /usr/local/lib/python2.7/dist-packages/odoo-tester-libs/
ENV PATH=$PATH:/usr/local/lib/python2.7/dist-packages/odoo-tester-libs

# We use this folder in the CI as a testbed
ENV ODOO_BASEPATH=/testbed
RUN mkdir -p /testbed/addons && chown -R odoo:odoo /testbed

# We cannot switch back here, as in most CIs
# the repository would not be cloned as the odoo
# user, so we need to manipulate permissions
# as root and then use gosu

# USER odoo

ENTRYPOINT []
CMD []
