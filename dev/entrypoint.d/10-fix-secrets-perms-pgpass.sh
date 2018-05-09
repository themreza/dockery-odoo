#!/bin/bash

# During local development, using docker-compose without swarm mode
# secrets are simply bind mounted but without taking permissions
# or ownersip into account. This is an indirection fixing permission to 600
# on startup and set the right owner.

# This is useful if you want to use a .pgpass which, restricts on
# permissions, in your docker-compose development workflow

# https://github.com/docker/compose/issues/4994

set -e
for file in $(find "/run/secrets" -maxdepth 1 -mindepth 1 -xtype f -name "*_insecure"); do
	cp "${file}" "${file%_insecure}"
	chown ${APP_UID}:${APP_GID} "${file%_insecure}"
	chmod 0600 "${file%_insecure}"
    echo "Fixed ${file} to ${file%_insecure} with 0600"
done;



ARG  FROM_IMAGE=xoes/dockery-odoo
FROM ${FROM_IMAGE}

RUN pip install telegram

curl -L /raw.github

docker-compose.yml