#!/bin/bash
# wait-for-postgres.sh
set -Eeuo pipefail

# Load values from config

files=($(grep -lR "${ODOO_RC}" -e '^db_host'))
if [ "$files" ]; then PGHOST=$(awk -F "=" '/db_host/ {print $2}' "${files[-1]}" | tr -d ' '); fi
files=($(grep -lR "${ODOO_RC}" -e '^db_user'))
if [ "$files" ]; then PGUSER=$(awk -F "=" '/db_user/ {print $2}' "${files[-1]}" | tr -d ' '); fi
files=($(grep -lR "${ODOO_RC}" -e '^db_port'))
if [ "$files" ]; then PGPORT=$(awk -F "=" '/db_port/ {print $2}' "${files[-1]}" | tr -d ' '); fi
files=($(grep -lR "${ODOO_RC}" -e '^db_password'))
if [ "$files" ]; then PGPASSWORD=$(awk -F "=" '/db_password/ {print $2}' ${files[-1]} | tr -d ' '); fi
PGHOST=${PGHOST:="db"}
PGUSER=${PGUSER:="odoo"}
PGPORT=${PGPORT:="5432"}
PGPASSWORD=${PGPASSWORD:="odoo"}

# Connection provided by pgpass file
until psql -h "${PGHOST}" ${PGUSER} -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
