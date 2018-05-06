#!/bin/bash
set -e


scriptname=$(basename $0 .sh)
scriptnamefolder = ${scriptname}.d


function load_scriptnamefolder_scripts {
	for file in $(find /${scriptnamefolder} -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
	    echo Sourcing "$file" > /dev/stderr
	    source $file
	done
}


# Dealing with Rancher v1.*, which has no ConfigSets
for folder in $(find /run/secrets -maxdepth 1 -mindepth 1 -type f -name "__*" ); do
	target=${folder#/run/secrets/}
	target=${target//__//}
	mkdir -p ${target%/*}
	rm -f ${target}
	cp -rp "${folder}" "${target}"
    echo "Copied ${folder} to ${target} (Rancher Indirection)"
done;

ODOO_CMD="/opt/odoo/odoo-bin"
RUN=$@

if [ "${1:0:1}" = '-' ]; then
	set -- run "$@"
fi

if [ "$1" = 'run' ]; then
	shift;
	load_scriptnamefolder_scripts
	RUN="${ODOO_CMD}  --addons-path ${ADDONSPATH} $@"
fi

if [ "$1" = 'shell' ]; then
	shift;
	load_scriptnamefolder_scripts
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
