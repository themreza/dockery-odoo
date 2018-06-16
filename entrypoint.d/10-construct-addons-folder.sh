#!/bin/bash
# Generate Odoo addons folder scanning the folder
set -Eeuo pipefail

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
export ADDONSPATH=$addonspath
