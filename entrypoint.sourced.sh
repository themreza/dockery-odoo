#!/bin/bash
set -Eeuxo pipefail

function sourceScriptsInFolder {
	for file in $(find "$1" -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
	    echo Sourcing "$file"

		# shellcheck disable=SC1091
		# shellcheck source=entrypoint.d/
	    source "$file"
	done
}