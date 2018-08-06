#!/bin/bash
set -e

source /entrypoint.sourced.sh

sourceScriptsInFolder "entrypoint.d"

CMD="marabunta $@"

set -x
exec ${CMD}
