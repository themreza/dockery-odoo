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

source /entrypoint.0.sh

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

if [ "$1" = 'apply-patches' ]; then
	shift;
	# additional arguments will be passed to patch
	# Bind mount (writable) you odoo folder
	# while appling those patches
	CMD="apply-patches --quiet $@"
fi

set -x
exec ${CMD}
