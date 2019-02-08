FROM xoelabs/dockery-odoo-base:master

# ============================================================
# Forward enforce minimal naming scheme on secondary build
# ============================================================
ONBUILD COPY --chown=odoo:odoo  vendor/odoo/cc/odoo-bin     "${ODOO_CMD}"
ONBUILD COPY --chown=odoo:odoo  vendor/odoo/cc/odoo         "${ODOO_FRM}"
ONBUILD COPY --chown=odoo:odoo  vendor/odoo/cc/addons       "${ODOO_ADDONS_BASEPATH}"/000
ONBUILD COPY --chown=odoo:odoo  vendor/odoo/ee              "${ODOO_ADDONS_BASEPATH}"/001
ONBUILD COPY --chown=odoo:odoo  src                         "${ODOO_ADDONS_BASEPATH}"/090
ONBUILD COPY --chown=odoo:odoo  .migration.yml              "${ODOO_BASEPATH}"/.migration.yml
ONBUILD COPY --chown=odoo:odoo  .cfg-default.ini            "${ODOO_RC}"/01-default
ONBUILD RUN /patches ${ODOO_BASEPATH} || true

# ============================================================