#!/bin/bash
set -e

function load_entrypoint_scripts {
	folder=$(basename $0 .sh)
	for file in $(find /$folder.d -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
	    echo Sourcing "$file" > /dev/stderr
	    source $file
	done
}

if [ "${1:0:1}" = '-' ]; then
	set -- run "$@"
fi

ODOO_CMD="/opt/odoo/odoo-bin"
RUN=$@

if [ "$1" = 'run' ]; then
	shift;
	load_entrypoint_scripts
	RUN="${ODOO_CMD}  --addons-path ${ADDONSPATH} $@"
fi

if [ "$1" = 'shell' ]; then
	shift;
	load_entrypoint_scripts
	RUN="${ODOO_CMD} shell --addons-path ${ADDONSPATH} $@"
fi

if [ "$1" = 'scaffold' ]; then
	RUN="${ODOO_CMD} $@"
fi

if [ "$1" = 'deploy' ]; then
	RUN="${ODOO_CMD} $@"
fi

set -x
exec ${RUN}
