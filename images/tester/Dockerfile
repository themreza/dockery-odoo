ARG  FROM_IMAGE=xoelabs/dockery-odoo
FROM ${FROM_IMAGE}

USER root
# python and odoo linting setup
RUN pip install --upgrade --pre pylint-odoo
RUN pip install pylint-mccabe coverage
# For chrome bworser testing
RUN pip install websocket-client

# Some git tools for standard diffing
RUN apt-get update && apt-get install -y --no-install-recommends git-core

# Some git tools for standard diffing
RUN apt-get update && apt-get install -y --no-install-recommends jq

ENV GOSU_VERSION 1.10
RUN wget https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }') && \
	mv gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }') /usr/local/bin/gosu && \
	chmod +x /usr/local/bin/gosu

# For chrome bworser testing
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install -y --no-install-recommends google-chrome-stable

# For js test recordings
# Not avaialble in jessie
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg || true
# Add a chrome user and setup home dir.
RUN groupadd --system chrome && \
    useradd --system --create-home --gid chrome --groups audio,video chrome && \
    mkdir --parents /home/chrome/reports && \
    chown --recursive chrome:chrome /home/chrome

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
