#!/bin/bash
# Alter environment variables to work with marabunta
export MARABUNTA_ODOO_ADDONS_PATH="${ADDONSPATH}"
export PGHOST="${MARABUNTA_DB_HOST}"
export PGUSER="${MARABUNTA_DB_USER}"
export PGPORT="${MARABUNTA_DB_PORT}"
export PGPASSWORD="${MARABUNTA_DB_PASSWORD}"