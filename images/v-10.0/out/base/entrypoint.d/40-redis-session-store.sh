#!/bin/bash

set -Eeuo pipefail

if [ "$2" = 'odoo-redis' ]; then
	sourceScriptsInFolder "/entrypoint.db.d"
	CMD=(
			"${ODOO_CMD}"
			"--redis"
			"True"
			"--addons-path"
			"${ODOO_ADDONS_PATH}"
			"${CMD[@]:1}"
		)
fi
