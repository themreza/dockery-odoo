#!/bin/bash

# This returns the quick connect URL to your Odoo Staging instance.
# Usage:
# url=$(get-quickconnect-url [--ssl] HOST DBSLUG)



if [ "$1" = '--ssl' ]; then
	shift;
	schema="https"
else
	schema="http"
fi

if [ "${1:0:1}" = '' ] || [ "${1:0:1}" = - ] || [ "${2:0:1}" = '' ]; then
	echo "Usage: url=$(get-quickconnect-url [--ssl] HOST DBSLUG)"
	exit 0
fi

host="$1"
dbslug="$2"


echo "${schema}://${host}/web/login?db=${dbslug}-all&login=admin&redirect=/web?debug=1"
