#!/bin/bash

set -e
# If we are in a CI environment, just prefix with the environments project folder
# This enables namespaced parallel builds
ciprojectfolder=${CI_PROJECT_DIR}

admin_passwd_config="admin_passwd = $(
    if [ -f ${ciprojectfolder}/run/secrets/odoo_admin_password ];then
        cat ${ciprojectfolder}/run/secrets/odoo_admin_password;
    else
        echo "default-admin-password-which-is-so-long-and-has-strange-signs-$}!-so-that-I-will-be-happy-to-change-it-soon";
    fi;
)"
sed -i -e "s/^admin_passwd =.*$/$admin_passwd_config/g" ~/.odoorc
log INFO --Admin password appended to [options] section in ~/.odoorc
