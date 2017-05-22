#!/bin/bash

set -e

export PGUSER="$(
    if [ -f /run/secrets/db_user ];then
        cat /run/secrets/db_user;
    else
        echo "odoo";
    fi;
)"

export PGPASSWORD="$(
    if [ -f /run/secrets/db_password ];then
        cat /run/secrets/db_password;
    else
        echo "odoo";
    fi;
)"

sed -i -e "s/^db_user =.*$/db_user = $PGUSER/g" ~/.odoorc
sed -i -e "s/^db_password =.*$/db_password = $PGPASSWORD/g" ~/.odoorc
log INFO --DB credentials appended to [options] section in ~/.odoorc
