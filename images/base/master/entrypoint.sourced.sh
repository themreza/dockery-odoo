#!/bin/bash

# Loads sourceScriptsInFolder function.
# This function sources all scripts in a folder that has been passed as first
# argument. Usually loaded in the main entrypoint.

set -Eeuxo pipefail


function sourceScriptsInFolder {
	for file in $(find "$1" -maxdepth 1 -mindepth 1 -xtype f -exec realpath {} + | sort); do
	    echo Sourcing "$file"

		# shellcheck disable=SC1091
		# shellcheck source=entrypoint.d/
	    source "$file"
	done
}