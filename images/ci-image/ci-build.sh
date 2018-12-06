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
    image="${IMAGE}:${1}-${ODOO_VERSION}"
else
    image="${IMAGE}:${1}-${ODOO_VERSION}-${2}"
fi

fromimage="${FROM}:${ODOO_VERSION}-${1}"

# Build from remote "from" image
docker build --tag "${image}" \
    --build-arg FROM_IMAGE="${fromimage}" \
    .

docker push "${image}" &> /dev/null
