#!/bin/bash
set -Eeuxo pipefail

# Runtime Env
export ODOO_RC=${ODOO_RC:="${ODOO_BASEPATH}/.odoorc.d"}  # Bind-mount a folder (Patch tools/0001)
export ODOO_PASSFILE=${ODOO_PASSFILE:="/run/secrets/adminpwd"}  # Odoo Passfile (Patch tools/0002)

export PGPASSFILE=${PGPASSFILE:="/run/secrets/pgpass"}
export PGHOST=${PGHOST:="db"}



addonspath=""
# Sort reverse alfanumerically first, then do realpath 
# so we can freely reorder loading by symlinking for
# exemple in a CI environment directly from a git clone.
for dir in $(find "${ADDONS_BASE}" -maxdepth 1 -mindepth 1 -xtype d | sort -r | xargs realpath); do
    echo "Adding $dir to addons path"
    if [ -z "$addonspath" ]; then
        addonspath=$dir
    else
        addonspath=$addonspath,$dir
    fi;
done;
export ODOO_ADDONSPATH=$addonspath
