#!/bin/bash
set -e

folder=$(basename $0 .sh)
for file in $(find /home/$folder.d -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
    log INFO Executing build "$file" > /dev/stderr
    exec $file
done
