ARG  FROM_IMAGE=xoes/dockery-odoo
FROM ${FROM_IMAGE}


USER root
# develpoment libraries
RUN pip install \
        astor \
        ptpython \
        pudb \
        pyinotify \
        watchdog \
        wdb

# python and odoo linting setup
RUN pip install --upgrade --pre pylint-odoo
RUN pip install pylint-mccabe coverage

# Odoo Scaffolding dependency
RUN pip install pick

# --- WDB Configuration ---
ENV WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost

COPY entrypoint.d/* /entrypoint.d/
COPY templates /templates

USER odoo

# When you use scaffold, create new module in ./src aka 090
WORKDIR ${ODOO_BASEPATH}/addons/090
