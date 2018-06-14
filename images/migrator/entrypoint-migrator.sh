#!/bin/bash
set -e

source /entrypoint.0.sh

source_scripts

CMD="marabunta $@"

set -x
exec ${CMD}
