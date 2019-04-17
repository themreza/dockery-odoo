#!/bin/bash


set -Eeuo pipefail


if [ "$2" = 'migrate-dev-wrapper' ]; then
	if [ "$#" -ne 4 ] || [ "$3" = "$2" ] || [ "$4" = "$2" ] || [ "$3" = "$4" ]; then
		echo "${LRED}Before migration, the system creates a copy of the database"
		echo "please make sure that the name of origin and target database are different"
		echo "usage:          migrate [origin target]"
		echo "arguments:"
		echo "origin:         Database's name to copy"
		echo "target:         Database copy name"
		exit 1
	else
		CMD=(bash -c "dodoo copy --force-disconnect $3 $4 && dodoo migrate --file ${ODOO_MIG} --database $4")
	fi
fi
