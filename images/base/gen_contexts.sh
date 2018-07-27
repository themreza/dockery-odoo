#!/bin/bash

# Generates base images docker contexts.
# Recursively copies (merges) files from ./common and
# curls the newest version of the "official" requirements.txt

set -Eeuxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"



for version in $(find "${DIR}" -maxdepth 1 -type d -name 'v*'); do
	cp -rp "${DIR}"/common/* "${version}/"
done

curl https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt -o "${DIR}"/v10/requirements.txt
curl https://raw.githubusercontent.com/odoo/odoo/11.0/requirements.txt -o "${DIR}"/v11/requirements.txt