#!/bin/sh


# Usage: ci-build.sh [base|devops] <HASH>

set -eux

options="base devops"
validate() { echo "${options}" | grep -F -q -w "$1"; }

if [ $# -eq 0 ] || [ $# -gt 2 ] || validate "${1}" ; then
	echo "Usage: ci-build.sh [base|devops] <HASH>"
 	exit 1
fi

fromimage="${FROM}:${ODOO_VERSION}"

if [ $# -eq 1 ]; then
    image="${IMAGE}:${1}-${ODOO_VERSION}"
	base="${IMAGE}:base-${ODOO_VERSION}"
else
    image="${IMAGE}:${1}-${ODOO_VERSION}-${2}"
	base="${IMAGE}:base-${ODOO_VERSION}-${2}"
fi

if [ "${1}" != "base" ]; then

	# Build non-base from base image
	docker build --tag "${image}" \
	    --build-arg FROM_IMAGE="${base}" \
	    "${FROMREPO}#master:images/${1}"

else

	# Build base from remote "from" image
	docker build --tag "${image}" \
	    --build-arg FROM_IMAGE="${fromimage}" \
	    .
fi

docker push "${image}" &> /dev/null
