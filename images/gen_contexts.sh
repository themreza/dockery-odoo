#!/bin/bash

# Generates base images docker contexts.
# Recursively copies (merges) files from ./common and
# curls the newest version of the "official" requirements.txt

set -Eeuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


for path in $(find "${DIR}" -maxdepth 1 -type d -name 'v-*') ; do
	name=$(basename "${path}")
	version=${name#"v-"}
	shopt -s extglob
	cp -rp "${DIR}"/common/* "${path}/out/"
	cp -rp "${path}"/spec/*  "${path}/out/"
	cat "$path/out/base/__Dockerfile" >> "$path/out/base/Dockerfile"
	cat "$path/out/devops/__Dockerfile" >> "$path/out/devops/Dockerfile"
	find "${path}/out/" -name "__*" -type f -exec rm {} \+
done
