#!/bin/bash
set -e

# In Repository						In Container
# --------------------------		-------------------
# ./vendor/odoo/cc/odoo-bin 	-> 	/opt/odoo/odoo-bin
# ./vendor/odoo/cc/odoo 		-> 	/opt/odoo/odoo
# ./vendor/odoo/cc/addons 		-> 	/opt/odoo/addons/000
# ./vendor/odoo/ee/				-> 	/opt/odoo/addons/001
# ./vendor/...					-> 	/opt/odoo/addons/...
# ./src/						-> 	/opt/odoo/addons/090
# ./cfg/						-> 	/opt/odoo/.odoorc.d

# NOTE: ee is required, put an .empty file if not used.

# This is accomplished by a limited set of ONBUILD statments
# Strong naming convention (inspired by golang) is enforced
# as an attempt to increase long term portability.



: ${ODOO_BASEPATH:="/opt/odoo"}  # Switch easily in CI environment
: ${ODOO_CMD:="${ODOO_BASEPATH}/odoo-bin"}
: ${ODOO_RC:="${ODOO_BASEPATH}/.odoorc.d"}  # Bind-mount a folder (Patch 0005)
: ${ADDONS_BASE:="${ODOO_BASEPATH}/addons"}

# Those are fixed at build time (only here for reference)
: ${APP_UID:="9001"}
: ${APP_GID:="9001"} 


# Source *.d folder based on this script's name

script_name=$(basename $0 .sh)
script_name_folder = ${script_name}.d

function source_scripts {
	for file in $(find /${script_name_folder} -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
	    echo Sourcing "$file" > /dev/stderr
	    source $file
	done
}

# Implemented command options

CMD=$@

if [ "${1:0:1}" = '-' ]; then
	set -- run "$@"
fi

if [ "$1" = 'run' ]; then
	shift;
	source_scripts
	CMD="${ODOO_CMD} \
		--addons-path ${ADDONSPATH} \
		$@"
fi

if [ "$1" = 'shell' ]; then
	shift;
	database="$1"
	shift;
	source_scripts
	CMD="${ODOO_CMD} \
		shell \
		--addons-path ${ADDONSPATH} \
		-d "${database}" \
		$@"
fi

if [ "$1" = 'scaffold' ]; then
	CMD="${ODOO_CMD} $@"
fi

if [ "$1" = 'deploy' ]; then
	CMD="${ODOO_CMD} $@"
fi

set -x
exec ${CMD}
