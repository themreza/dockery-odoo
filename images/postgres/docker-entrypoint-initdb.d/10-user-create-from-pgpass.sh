#!/bin/bash
set -e


file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env APP_PGPASS ''


psql=( psql -v ON_ERROR_STOP=1)

printf '%s\n' "${APP_PGPASS}" | while IFS= read -r line
do
	[[ "$line" =~ ^#.*$ ]] && continue
	# Create User from .pgpass
	dbname=$(echo "$line" | cut -d: -f3)
	dbuser=$(echo "$line" | cut -d: -f4)
	passwd=$(echo "$line" | cut -d: -f5)
	# pgpassfile escaping, see: https://www.postgresql.org/docs/10/static/libpq-pgpass.html
	passwd=${passwd//\\:/:}
	passwd=${passwd//\\\\/\\}

	ARGS=

	[ "$passwd" != "" ] && ARGS="${ARGS} PASSWORD"
	if [ "$dbuser" == "repmgr" ]; then
		ARGS="SUPERUSER ${ARGS}"
	else
		ARGS="CREATEDB ${ARGS}"
	fi

	"${psql[@]}" --username "$POSTGRES_USER" <<-EOSQL
		DO
		\$body$
		BEGIN
		   IF NOT EXISTS (
		      SELECT
		      FROM   pg_catalog.pg_user
		      WHERE  usename = '$dbuser') THEN

		      CREATE USER "$dbuser" WITH ${ARGS} '$passwd';
		   END IF;
		END
		\$body$;
	EOSQL

	[ "$dbname" != "*" ] && createdb $dbname -O $dbuser

done


# Forbid login with postgres (only local/trust)
"${psql[@]}" --username "$POSTGRES_USER" <<-EOSQL
	ALTER ROLE "$POSTGRES_USER" WITH PASSWORD NULL;
EOSQL