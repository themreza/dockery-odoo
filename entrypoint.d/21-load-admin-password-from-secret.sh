#!/bin/bash

set -e
# If we are in a CI environment, just prefix with the environments project folder
# This enables namespaced parallel builds
ciprojectfolder=${CI_PROJECT_DIR}

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	echo $def
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${ciprojectfolder}${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env ADMIN_PASSWD "default-admin-password"
echo $ADMIN_PASSWD

sed -i -e "s/^admin_passwd =.*$/admin_passwd = $ADMIN_PASSWD/g" ~/.odoorc
log INFO --Admin password appended to [options] section in ~/.odoorc
