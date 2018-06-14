#!/bin/bash
set -e


: ${ODOO_BASEPATH:="/opt/odoo"}  # Switch easily in CI environment
: ${ODOO_CMD:="${ODOO_BASEPATH}/odoo-bin"}
: ${ODOO_RC:="${ODOO_BASEPATH}/.odoorc.d"}  # Bind-mount a folder (Patch 0005)
: ${ADDONS_BASE:="${ODOO_BASEPATH}/addons"}

# Those are fixed at build time (only here for reference)
: ${APP_UID:="9001"}
: ${APP_GID:="9001"} 


entrypoint_scripts=entrypoint.d

function source_scripts {
	for file in $(find /${entrypoint_scripts} -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
	    echo Sourcing "$file"
	    source $file
	done
}