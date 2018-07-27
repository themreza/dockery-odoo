#!/bin/bash

# Generates base images per version.
# Walkes folders matching'v*' and builds their respectiv docker context.
# Before that, calls gen_context in order the build contexts

set -Eeuxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


source "${DIR}"/gen_contexts.sh

for version in $(find "${DIR}" -maxdepth 1 -type d -name 'v*'); do
	name=$(basename ${version})
	docker build --tag "${1}:${name}" "${version}"
done
