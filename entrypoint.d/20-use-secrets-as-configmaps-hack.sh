#!/bin/bash
set -Eeuo pipefail

# In a environment with no ConfigSets, you can use 
# this hack to pass configuration through secrets
# Prefix the secret with "__" within the container

for folder in $(find /run/secrets -maxdepth 1 -mindepth 1 -type f -name "__*" ); do
	target=${folder#/run/secrets/}
	target=${target//__//}
	mkdir -p ${target%/*}
	rm -f ${target}
	cp -rp "${folder}" "${target}"
    echo "Copied ${folder} to ${target} (Secrets Indirection)"
done;
