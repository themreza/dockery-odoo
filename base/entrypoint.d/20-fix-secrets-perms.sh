#!/bin/bash
set -e
for file in $(find /run/secrets -maxdepth 1 -mindepth 1 -xtype f -name "*_insecure"); do
	cp "${file}" "${file%_insecure}"
	chown ${APP_UID}:${APP_GID} "${file%_insecure}"
	chmod 0600 "${file%_insecure}"
    echo "Fixed ${file} to ${file%_insecure} with 0600"
done;
