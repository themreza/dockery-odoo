#!/bin/bash

set -e
# If we are in a CI environment, just prefix with the environments project folder
# This enables namespaced parallel builds
ciprojectfolder=${CI_PROJECT_DIR}

export PGUSER="$(
    if [ -f ${ciprojectfolder}/run/secrets/db_user ];then
        cat ${ciprojectfolder}/run/secrets/db_user;
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
