#!/bin/bash
# Generate Odoo server configuration from templates

set -e
src=""
for file in $(find /home/config.d -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
        log INFO --Expanding contents of "$file" > /dev/stderr
        src="$src $file"
done

log INFO --Merging $(ls $src | wc -l) configuration files into ~/.odoorc
conf=$(cat $src | envsubst)
log DEBUG -Resulting configuration:"\n $conf"
echo "$conf" >| ~/.odoorc
log DEBUG -Configuration written to ~/.odoorc
