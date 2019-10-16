FROM xoelabs/dockery-odoo-base:11.0
# ============================================================
# Convention about required libraries
# ============================================================

USER root

RUN pip --quiet --quiet install --no-cache-dir redis prometheus_client; \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +;

# ============================================================
# Convention about environment variables
# ============================================================

ENV ODOO_BASEPATH        "/opt/odoo"
ENV ODOO_RC              "${ODOO_BASEPATH}/cfg.d"
ENV ODOO_MIG             "${ODOO_BASEPATH}/migration.yaml"
ENV ODOO_MIG_DIR         "${ODOO_BASEPATH}/migration.d"
ENV ODOO_CMD             "${ODOO_BASEPATH}/vendor/odoo/cc/odoo-bin"
ENV ODOO_FRM             "${ODOO_BASEPATH}/vendor/odoo/cc"
ENV ODOO_VENDOR          "${ODOO_BASEPATH}/vendor"
ENV ODOO_SRC             "${ODOO_BASEPATH}/src"
ENV PATCHES_DIR          "${ODOO_BASEPATH}/patches.d"

# ============================================================
# Ship with conventional files (patches, entrypoints, bin)
# ============================================================

COPY patches.d "${PATCHES_DIR}"
COPY entrypoint.d/* /entrypoint.d/
COPY bin/* /usr/local/bin/
RUN /bin/bash -c 'shopt -s dotglob \
 && chmod +x /entrypoint.d/* \
 && chmod +x /usr/local/bin/* \
 && shopt -u dotglob'


# ============================================================
# Forward enforce minimal naming scheme on secondary build
# ============================================================

ONBUILD ENV LAYER_SUFFIX "-9"
ONBUILD ENV ODOO_VENDOR  "${ODOO_VENDOR} ${ODOO_BASEPATH}/vendor${LAYER_SUFFIX}"
ONBUILD ENV ODOO_SRC     "${ODOO_SRC} ${ODOO_BASEPATH}/src${LAYER_SUFFIX}"
ONBUILD ENV ODOO_CMD     "${ODOO_BASEPATH}/vendor${LAYER_SUFFIX}/odoo/cc/odoo-bin"
ONBUILD ENV ODOO_FRM     "${ODOO_BASEPATH}/vendor${LAYER_SUFFIX}/odoo/cc"
ONBUILD COPY --chown=odoo:odoo  migration.yaml              "${ODOO_MIG}"
ONBUILD COPY --chown=odoo:odoo  migration.d                 "${ODOO_MIG_DIR}"
ONBUILD COPY --chown=odoo:odoo  patches.d/*                 "${PATCHES_DIR}/"
ONBUILD COPY --chown=odoo:odoo  vendor                      "${ODOO_BASEPATH}/vendor"
ONBUILD COPY --chown=odoo:odoo  src                         "${ODOO_BASEPATH}/src"
ONBUILD RUN /patches ${ODOO_BASEPATH} || true; \
			mv "${ODOO_BASEPATH}/vendor" "${ODOO_BASEPATH}/vendor${LAYER_SUFFIX}"; \
			mv "${ODOO_BASEPATH}/src" "${ODOO_BASEPATH}/src${LAYER_SUFFIX}";

# ============================================================