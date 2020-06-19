FROM xoelabs/dockery-odoo-base:12.0


# ============================================================
# ------------------------------------------------------------
#
# Dockery Odoo Prod
#
# ------------------------------------------------------------
# ============================================================

USER root

# ============================================================
# Prod: convention about required libraries
# ============================================================

# ============================================================
# Prod: convention about source code layout (layer 9)
# ============================================================

# "odoo9", so you can stack projects up to "odoo0"

ENV ODOO_BASEPATH        "/opt/odoo9"

ENV ODOO_FRM             "${ODOO_BASEPATH}/odoo/"
ENV ODOO_RC              "${ODOO_BASEPATH}/odoo.conf"
ENV ODOO_CMD             "${ODOO_BASEPATH}/odoo/odoo-bin"
ENV ODOO_VENDOR          "${ODOO_BASEPATH}/vendor"
ENV ODOO_SRC             "${ODOO_BASEPATH}/src"

ENV PATCH_DIR            "${ODOO_BASEPATH}/_patch.d"
ENV MIG_DIR              "${ODOO_BASEPATH}/_mig.d"
ENV MIG_YAML             "${ODOO_BASEPATH}/_mig.d/mig.yaml"

ONBUILD COPY --chown=odoo:odoo  vendor    "${ODOO_VENDOR}"
ONBUILD COPY --chown=odoo:odoo  odoo      "${ODOO_FRM}"
ONBUILD COPY --chown=odoo:odoo  src       "${ODOO_SRC}"

ONBUILD COPY --chown=odoo:odoo  _patch.d   "${PATCH_DIR}"
ONBUILD COPY --chown=odoo:odoo  _mig.d     "${MIG_DIR}"


# ============================================================
# Prod: conventional files (entrypoints, bin)
# ============================================================

COPY entrypoint.d/* /entrypoint.d/
COPY bin.d/* /usr/local/bin/
RUN /bin/bash -c 'shopt -s dotglob \
 && chmod +x /entrypoint.d/* \
 && chmod +x /usr/local/bin/* \
 && shopt -u dotglob'



# ============================================================
# ------------------------------------------------------------
#
# Dockery Odoo Devops Additions
#
# ------------------------------------------------------------
# ============================================================


USER root

# ============================================================
# Devops: conventionalized devops environment
# ============================================================

ENV WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost \
    PYTHONPATH=${PYTHONPATH}:${ODOO_FRM} \
    DODOO_LOAD_OUT=/var/lib/dodoo-loader/logs.json

# Prepare odoo owned testlog folder for chrome screenshots
# Prepare odoo owned loading log folder for dodoo loader
RUN mkdir -p /var/log/dodoo/tests; \
    chown odoo:odoo /var/log/dodoo/tests; \
    mkdir -p /var/log/dodoo/loader; \
    chown odoo:odoo /var/log/dodoo/loader


# ============================================================
# Devops: conventionalized devops working directory
# ============================================================

# Can be relied upon for code analyzers or generators which are
# run from within the container

WORKDIR ${ODOO_BASEPATH}/src


# ============================================================
# Devops: convention about general devops tools
# ============================================================

# Size: ca. 57MB
RUN apt-get -qq update && apt-get -qq install -y curl wget mtr net-tools gnupg



# ============================================================
# Devops: browser testing (chrome headless)
# ============================================================

# Size: ca. 291MB
RUN wget --quiet -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get -qq update && apt-get -qq install -y --no-install-recommends google-chrome-stable > /dev/null



# ============================================================
# Devops: conventional python tools (dodoo, analyzers, etc)
# ============================================================

# Size: ca. 138MB
RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        #
        # ================================================
        # setup build dependencies for python packages ...
        # ================================================
        #
        build-essential \
        automake \
        libtool; \
        pip --quiet --quiet install --no-cache-dir \
            #
            # ================================================
            # dodoo devops toolchain
            # ================================================
            #
            dodoo-tester \
            dodoo-initializer \
            dodoo-loader \
            dodoo-migrator \
            #
            # ================================================
            # additional odoo development tooling
            # ================================================
            #
            odoo-module-migrator \
            #
            # ================================================
            # analyzers, linters, debuggers, repls, tooling
            # ================================================
            #
            astor \
            pylint-odoo \
            pylint-mccabe \
            coverage \
            ptpython \
            pudb \
            pyinotify \
            watchdog \
            wdb \
            jq \
            #
            # ================================================
            # browser testing, js test recording
            # ================================================
            #
            websocket-client \
            ffmpeg; \
            #
            # ================================================
            # still trying to keep it minimal ...
            # (more style than reason)
            # ================================================
            #
        find /usr/local -depth \
            \( \
                \( -type d -a \( -name test -o -name tests \) \) \
                -o \
                \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
            \) -exec rm -rf '{}' +; \
    #
    # ================================================
    # and remove build dependencies again ...
    # (slightly more reason than style)
    # ================================================
    #
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*;
