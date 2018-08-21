#!/bin/bash

# Generates base images docker contexts.
# Recursively copies (merges) files from ./common and
# curls the newest version of the "official" requirements.txt

set -Eeuxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


for path in $(find "${DIR}" -maxdepth 1 -type d -name 'v-*') ; do
	name=$(basename "${path}")
	version=${name#"v-"}
	cp -rp "${DIR}"/common/* "${path}/"
	cat "$path/_patches" >> "$path/patches"
	cat "$path/_Dockerfile" > "$path/Dockerfile"
	cat "$path/_Dockerfile.common" >> "$path/Dockerfile"
	curl "https://raw.githubusercontent.com/odoo/odoo/${version}/requirements.txt" -o "${DIR}/${name}/requirements.txt"
done
