#!/bin/sh


# Usage: ci-build.sh [base|devops] <HASH>

set -eux

options="base devops"
validate() { echo "${options}" | grep -F -q -w "$1"; }

if [ $# -eq 0 ] || [ $# -gt 2 ] || ! validate "${1}" ; then
	echo "Usage: ci-build.sh [base|devops] <HASH>"
 	exit 1
fi


if [ $# -eq 1 ]; then
    image="${IMAGE}:${ODOO_VERSION}-${1}"
else
    image="${IMAGE}:${ODOO_VERSION}-${1}-${2}"
fi

fromimage="${FROM}:${1}-${ODOO_VERSION}"

# Build from remote "from" image
docker build --tag "${image}" \
    --build-arg FROM_IMAGE="${fromimage}" \
    .

docker push "${image}" &> /dev/null
