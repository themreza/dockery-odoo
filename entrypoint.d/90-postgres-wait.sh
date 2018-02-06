#!/bin/bash
# wait-for-postgres.sh

set -e

# Connection provided by pgpass file
until psql -h "${PGHOST}" postgres -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
