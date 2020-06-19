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

