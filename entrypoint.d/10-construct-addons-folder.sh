#!/bin/bash
# Generate Odoo addons folder scanning the folder

set -e
addonspath=""
# Sort alfanumerically first, then do realpath so we can freely reorder loading
# by symlinking for exemple in a CI environment directly from a git clone.
for dir in $(find /opt/odoo/addons -maxdepth 1 -mindepth 1 -xtype d | sort | xargs realpath) $(realpath /opt/odoo/odoo/addons); do
    log INFO --Dynamically adding "$dir" to addons path > /dev/stderr
    if [ -z "$addonspath" ]; then
        addonspath=$dir
    else
        addonspath=$addonspath,$dir
    fi;
done;

log DEBUG -Exporting addonsdir to the environment
export ADDONSPATH=$addonspath
