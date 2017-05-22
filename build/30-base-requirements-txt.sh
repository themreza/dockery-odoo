#!/bin/bash
set -ex

reqs=https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt

apt-get update
apt_deps="python-dev build-essential"

# lxml
apt_deps="$apt_deps libxml2-dev libxslt1-dev"
# Pillow
apt_deps="$apt_deps libjpeg-dev libfreetype6-dev
    liblcms2-dev libopenjpeg-dev libtiff5-dev tk-dev tcl-dev"
# psutil
apt_deps="$apt_deps linux-headers-amd64"
# psycopg2
apt_deps="$apt_deps libpq-dev"
# python-ldap
apt_deps="$apt_deps libldap2-dev libsasl2-dev"

apt-get install -y --no-install-recommends $apt_deps

pip_deps="psutil==4.3.1 pydot==1.2.3"

pip install --no-cache-dir $pip_deps
pip install --no-cache-dir --requirement $reqs

# Remove all installed garbage
apt-get -y purge $apt_deps
apt-get -y autoremove
rm -Rf /var/lib/apt/lists/* /tmp/* || true
