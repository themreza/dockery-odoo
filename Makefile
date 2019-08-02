
gen:
	./images/gen_contexts.sh

build: build-10 build-11 build-12 build-master

build-10: gen
	docker build --tag "xoelabs/dockery-odoo:edge-10.0" "./images/v-10.0/out/base"
	docker build --tag "xoelabs/dockery-odoo:edge-10.0-devops" "./images/v-10.0/out/devops"

build-11: gen
	docker build --tag "xoelabs/dockery-odoo:edge-11.0" "./images/v-11.0/out/base"
	docker build --tag "xoelabs/dockery-odoo:edge-11.0-devops" "./images/v-11.0/out/devops"

build-12: gen
	docker build --tag "xoelabs/dockery-odoo:edge-12.0" "./images/v-12.0/out/base"
	docker build --tag "xoelabs/dockery-odoo:edge-12.0-devops" "./images/v-12.0/out/devops"

build-master: gen
	docker build --tag "xoelabs/dockery-odoo:edge-master" "./images/v-master/out/base"
	docker build --tag "xoelabs/dockery-odoo:edge-master-devops" "./images/v-master/out/devops"

push: push-10 push-11 push-12 push-master

push-10: build-10
	docker push xoelabs/dockery-odoo:edge-10.0
	docker push xoelabs/dockery-odoo:edge-10.0-devops
push-11: build-11
	docker push xoelabs/dockery-odoo:edge-11.0
	docker push xoelabs/dockery-odoo:edge-11.0-devops
push-12: build-12
	docker push xoelabs/dockery-odoo:edge-12.0
	docker push xoelabs/dockery-odoo:edge-12.0-devops
push-master: build-master
	docker push xoelabs/dockery-odoo:edge-master
	docker push xoelabs/dockery-odoo:edge-master-devops