#!/bin/bash

# Symlink git workdir folders of CI clone to testbed
# Relies on the repo folder structure and naming scheme.
# "05-" because it needs runing before "10-" of base image

set -e

# Covers Travis & Gitlab-CI ootb
# Travis: TRAVIS_BUILD_DIR
# Gitlab: CI_PROJECT_DIR
# Custom: CI_BUILD_DIR
: ${CI_BUILD_DIR:="${CI_PROJECT_DIR:="${TRAVIS_BUILD_DIR}"}"}

ln -s "${CI_BUILD_DIR}/vendor/odoo/cc/odoo-bin" /testbed/odoo-bin
ln -s "${CI_BUILD_DIR}/vendor/odoo/cc/odoo" 	/testbed/odoo
ln -s "${CI_BUILD_DIR}/vendor/odoo/cc/addons" 	/testbed/addons/000
ln -s "${CI_BUILD_DIR}/vendor/odoo/ee" 			/testbed/addons/001
ln -s "${CI_BUILD_DIR}/src" 					/testbed/addons/090
ln -s "${CI_BUILD_DIR}/cfg" 					/testbed/.odoorc.d
