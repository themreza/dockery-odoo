#!/bin/bash

set -e

# If we are in a CI environment, just prefix with the environments project folder
# This enables namespaced parallel builds
ciprojectfolder=${CI_PROJECT_DIR}
# If this is a migration sidekick, use a predefinde migrations user variant
migration=$(if [ ! -z ${MIGRATION_SIDEKICK_SUFFIX} ]; then echo "-{$MIGRATION_SIDEKICK_SUFFIX}"; fi)
# If we are in a deploy, use version tag suffix for the DB user
# EXAMPLE: odoouser-{10.0.0.5}
version=$(if [ ! -z ${CI_COMMIT_TAG} ]; then echo "-{$CI_COMMIT_TAG}"; fi)

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${ciprojectfolder}${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}


file_env PGUSER "odoo"
export PGUSER=$PGUSER$version$migration
file_env PGPASSWORD "odoo"

sed -i -e "s/^db_user =.*$/db_user = $PGUSER/g" ~/.odoorc
sed -i -e "s/^db_password =.*$/db_password = $PGPASSWORD/g" ~/.odoorc
log INFO --DB credentials appended to [options] section in ~/.odoorc
