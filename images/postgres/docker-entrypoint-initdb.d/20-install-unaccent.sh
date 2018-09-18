#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	\connect template1;
	CREATE EXTENSION unaccent;
EOSQL

# Odoo has changed the tamplate it uses for performance reason recently.
# So we just install on both templates.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	\connect template0;
	CREATE EXTENSION unaccent;
EOSQL