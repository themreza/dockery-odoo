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
	echo -e "Cleanup ${version} target..."
	rm -rf "${path}/out"
	mkdir -p "${path}/out/"
	echo -e "Copy to ${version} target..."
	cp -rp "${DIR}"/common/* "${path}/out/"
	cp -rp "${path}"/spec/*  "${path}/out/"
	echo -e "Build ${version} base Dockerfile from templates..."
	for tmpl in $(find "${path}/out/base" -name "Dockerfile.*.tmpl" -xtype f | sort | xargs realpath --no-symlinks); do
		cat ${tmpl} >> "${path}/out/base/Dockerfile"
		rm -f "${tmpl}"
	done
	echo -e "Build ${version} devops Dockerfile from templates..."
	for tmpl in $(find "${path}/out/devops" -name "Dockerfile.*.tmpl" -xtype f | sort | xargs realpath --no-symlinks); do
		cat ${tmpl} >> "${path}/out/devops/Dockerfile"
		rm -f "${tmpl}"
	done
	echo -e "\n"
done
