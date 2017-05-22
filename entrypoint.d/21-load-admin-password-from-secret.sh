#!/bin/bash

set -e
admin_passwd_config="admin_passwd = $(
    if [ -f /run/secrets/odoo_admin_password ];then
        cat /run/secrets/odoo_admin_password;
    else
        echo "default-admin-password-which-is-so-long-and-has-strange-signs-$}!-so-that-I-will-be-happy-to-change-it-soon";
    fi;
)"
sed -i -e "s/^admin_passwd =.*$/$admin_passwd_config/g" ~/.odoorc
log INFO --Admin password appended to [options] section in ~/.odoorc
