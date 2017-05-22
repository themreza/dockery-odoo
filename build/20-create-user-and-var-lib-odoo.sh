#!/bin/sh

addgroup --system --gid 9001 odoo
adduser --system --uid 9001 --ingroup odoo --home /opt/odoo --disabled-login --shell /sbin/nologin odoo
mkdir -p /var/lib/odoo
chown -R odoo:odoo /var/lib/odoo
