#!/bin/bash
set -Eeuxo pipefail


export ODOO_BASEPATH=${ODOO_BASEPATH:="/opt/odoo"}  # Switch easily in CI environment
export ODOO_CMD=${ODOO_CMD:="${ODOO_BASEPATH}/odoo-bin"}
export ODOO_RC=${ODOO_RC:="${ODOO_BASEPATH}/.odoorc.d"}  # Bind-mount a folder (Patch 0005)
export ADDONS_BASE=${ADDONS_BASE:="${ODOO_BASEPATH}/addons"}

# Those are fixed at build time (only here for reference)
export APP_UID=${APP_UID:="9001"}
export APP_GID=${APP_GID:="9001"} 


entrypoint_scripts=entrypoint.d

function source_scripts {
	for file in $(find /${entrypoint_scripts} -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
	    echo Sourcing "$file"
	    source $file
	done
}