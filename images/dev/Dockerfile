ARG  FROM_IMAGE=xoelabs/dockery-odoo
FROM ${FROM_IMAGE}


USER root
# local browser testing
RUN wget --quiet -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get -qq update && apt-get -qq install -y --no-install-recommends google-chrome-stable > /dev/null
# For js test recordings
# Not avaialble in jessie
RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends ffmpeg  > /dev/null || true

# develpoment libraries
RUN pip --quiet --quiet install \
        astor \
        ptpython \
        pudb \
        pyinotify \
        watchdog \
        wdb

# python and odoo linting setup
RUN pip  --quiet --quiet install --upgrade --pre pylint-odoo
RUN pip  --quiet --quiet install pylint-mccabe coverage

# For chrome bworser testing
RUN pip  --quiet --quiet install websocket-client

# Odoo Scaffolding dependency
RUN pip  --quiet --quiet install pick

# --- WDB Configuration ---
ENV WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost

COPY entrypoint.d/* /entrypoint.d/
COPY templates /templates

# Prepare odoo owned testlog folder for chrome screenshots
RUN mkdir -p /testlogs && chown odoo:odoo /testlogs

USER odoo

# When you use scaffold, create new module in ./src aka 090
WORKDIR ${ODOO_BASEPATH}/addons/090
