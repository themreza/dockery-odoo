#!/bin/sh

# Shows versions of some standard components present on a ci image

if $(which docker); then
	docker version
fi
if $(which kubectl); then
	kubectl version --client
fi
if $(which terraform); then
	terraform version
fi
if $(which consul); then
	consul version
fi
if $(which etcdctl); then
	etcdctl version
fi
