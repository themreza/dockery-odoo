#!/bin/sh

# Shows versions of some standard components present on a ci image

if $(which docker) > /dev/null; then
	docker version
fi
if $(which kubectl) > /dev/null; then
	kubectl version --client
fi
if $(which terraform) > /dev/null; then
	terraform version
fi
if $(which consul) > /dev/null; then
	consul version
fi
if $(which etcdctl) > /dev/null; then
	etcdctl version
fi
