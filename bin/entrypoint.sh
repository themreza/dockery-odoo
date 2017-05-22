#!/bin/bash
# Thanks Camptocamp for the idea!
# http://www.camptocamp.com/en/actualite/flexible-docker-entrypoints-scripts/
set -e

for file in $(find /home/entrypoint.d -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
    log INFO Sourcing entrypoint "$file" > /dev/stderr
    source $file
done

if [ -n "$1" ]; then
    set -x
    exec "$@"
fi
