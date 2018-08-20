#!/bin/bash

# Generates base images docker contexts.
# Recursively copies (merges) files from ./common and
# curls the newest version of the "official" requirements.txt

set -Eeuxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"



for version in $(find "${DIR}" -maxdepth 1 -type d -name 'v*') "master" ; do
	cp -rp "${DIR}"/common/* "${version}/"
	cat "$version/_patches" >> "$version/patches"
	cat "$version/_Dockerfile" > "$version/Dockerfile"
	cat "$version/_Dockerfile.common" >> "$version/Dockerfile"
done

curl https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt -o "${DIR}"/v10/requirements.txt
curl https://raw.githubusercontent.com/odoo/odoo/11.0/requirements.txt -o "${DIR}"/v11/requirements.txt
curl https://raw.githubusercontent.com/odoo/odoo/master/requirements.txt -o "${DIR}"/master/requirements.txt