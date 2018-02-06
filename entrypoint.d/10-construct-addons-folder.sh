#!/bin/bash
# Generate Odoo addons folder scanning the folder

set -e
addonspath=""
# Sort alfanumerically first, then do realpath so we can freely reorder loading
# by symlinking for exemple in a CI environment directly from a git clone.
for dir in $(find /opt/odoo/addons -maxdepth 1 -mindepth 1 -xtype d | sort | xargs realpath) $(realpath /opt/odoo/odoo/addons); do
    echo "Adding $dir to addons path"
    if [ -z "$addonspath" ]; then
        addonspath=$dir
    else
        addonspath=$addonspath,$dir
    fi;
done;
export ADDONSPATH=$addonspath
