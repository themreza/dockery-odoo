#!/bin/bash

set -e
# If we are in a CI environment, just prefix with the environments project folder
# This enables namespaced parallel builds
ciprojectfolder=${CI_PROJECT_DIR}
# If this is a migration sidekick, use a predefinde migrations user variant
migration=$(if [ ! -z ${MIGRATION_SIDEKICK_SUFFIX+x} ]; then echo "-{$MIGRATION_SIDEKICK_SUFFIX}"; fi)
# If we are in a deploy, use version tag suffix for the DB user
# EXCAMPLE: odoouser-{10.0.0.5}
version=$(if [ ! -z ${CI_COMMIT_TAG+x} ]; then echo "-{$CI_COMMIT_TAG}"; fi)

export PGUSER="$(
    if [ -f ${ciprojectfolder}/run/secrets/db_user ];then
        echo "$(cat ${ciprojectfolder}/run/secrets/db_user)$version$migration";
    else
        echo "odoo";
    fi;
)"

export PGPASSWORD="$(
    if [ -f ${ciprojectfolder}/run/secrets/db_password ];then
        cat ${ciprojectfolder}/run/secrets/db_password;
    else
        echo "odoo";
    fi;
)"

sed -i -e "s/^db_user =.*$/db_user = $PGUSER/g" ~/.odoorc
sed -i -e "s/^db_password =.*$/db_password = $PGPASSWORD/g" ~/.odoorc
log INFO --DB credentials appended to [options] section in ~/.odoorc
