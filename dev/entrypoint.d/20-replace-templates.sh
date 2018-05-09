#!/bin/bash

# Replace default tmeplates with the enhanced templates of this image
# If you have a template improvement, please consider a PR to upstream.

set -e

rm -rf "${ODOO_BASEPATH}"/odoo/cli/templates
ln -s /templates "${ODOO_BASEPATH}"/odoo/cli/templates
