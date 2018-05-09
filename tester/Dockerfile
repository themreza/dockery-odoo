ARG  FROM_IMAGE=xoes/dockery-odoo
FROM ${FROM_IMAGE}

USER root
# python and odoo linting setup
RUN pip install --upgrade --pre pylint-odoo
RUN pip install pylint-mccabe coverage

# Some git tools for standard diffing
RUN apt-get update && apt-get install -y --no-install-recommends git-core


COPY bin/* /usr/local/bin/
COPY entrypoint.d/* /entrypoint.d/
COPY lib/* /usr/local/lib/python2.7/dist-packages/odoo-tester-libs/
ENV PATH=$PATH:/usr/local/lib/python2.7/dist-packages/odoo-tester-libs

USER odoo

# We use this folder in the CI as a testbed
ENV ODOO_BASEPATH=/testbed
RUN mkdir -p /testbed/addons



ENTRYPOINT []
CMD []
