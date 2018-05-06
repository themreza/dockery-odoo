ARG  FROM_IMAGE=xoes/dockery-odoo
FROM ${FROM_IMAGE}

# python and odoo linting setup
RUN pip install --upgrade --pre pylint-odoo
RUN pip install pylint-mccabe coverage

# Some git tools for standard diffing
RUN apt-get update && apt-get install -y --no-install-recommends git-core


COPY lib/* /usr/local/lib/python2.7/dist-packages/odoo-tester-libs/
ENV PATH=$PATH:/usr/local/lib/python2.7/dist-packages/odoo-tester-libs

ENTRYPOINT []
CMD []
