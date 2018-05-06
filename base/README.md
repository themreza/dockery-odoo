# Project's Dockerfile

    # .docker/Dockerfile
    ARG  FROM_IMAGE=xoes/dockery-odoo
    FROM ${FROM_IMAGE}

    # Load framework
    COPY odoo-cc/odoo-bin  /opt/odoo/odoo-bin
    COPY odoo-cc/odoo      /opt/odoo/odoo

    # Load enterprise and community addons
    COPY odoo-ee           /opt/odoo/addons/80-odoo-ee
    COPY odoo-cc/addons    /opt/odoo/addons/90-odoo-cc
    
    # Your addons
    COPY addons1           /opt/odoo/addons/70-addons1
    COPY addons2           /opt/odoo/addons/60-addons2

# Build Auxiliary Images

To build auxiliary images, such as `tester`, `migrator`, `dev`, `translator` or `linter` on top of your project's image, you can build directly from the repo context.
Given your project image is `odoo/app`, you can:

	docker build \
	  --tag odoo/app:dev
	  --build-arg FROM_IMAGE=odoo/app \
	  https://github.com/xoes/dockery-odoo.git#shared:dev


For more info please visit: [Dockery Odoo] (https://github.com/xoes/dockery-odoo)