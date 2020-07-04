#!/bin/bash

# Resets the apps runtime env in a CI environment, given that
# ODOO_BASEPATH was changed

set -Eeuo pipefail

if [ ! -z "${CI+x}" ]; then
    echo "==>  Setting up paths in CI env"
	export ODOO_RC="${ODOO_BASEPATH}/odoo.conf"
	export ODOO_MIG="${ODOO_BASEPATH}/migration.yaml"
	export ODOO_CMD="${ODOO_BASEPATH}/odoo/odoo-bin"
	export ODOO_FRM="${ODOO_BASEPATH}/odoo"
	export ODOO_VENDOR="${ODOO_BASEPATH}/vendor"
	export ODOO_SRC="${ODOO_BASEPATH}/src"
	export PATCHES_DIR="${ODOO_BASEPATH}/patches.d"
	export PYTHONPATH="${PYTHONPATH}:${ODOO_FRM}"
fi
