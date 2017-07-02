FROM registry.gitlab.com/devco-odoo/docker-odoo-base:base

# Get secondary binaries and pythonscripts by default
ONBUILD COPY .docker/bin/*           /usr/local/bin/
ONBUILD COPY .docker/lib/*           /usr/local/lib/python2.7/dist-packages/odoo-docker-base-libs/
# Get secondary entrypoint scripts and config files
ONBUILD COPY .docker/entrypoint.d/*  /home/entrypoint.d/
ONBUILD COPY .docker/config.d/*      /home/config.d/
# Set executing bit on freshly added files, also
ONBUILD RUN chmod +x -R /home /usr/local/bin/ /usr/local/lib/python2.7/dist-packages/
# Automate secondary build steps in one single step
ONBUILD COPY .docker/build.d         /home/build.d
ONBUILD RUN ln /usr/local/bin/build-dir-exec.sh /usr/local/bin/build.sh
ONBUILD RUN chmod +x /home/build.d/*.sh && build.sh

# Load framework
ONBUILD COPY odoo-cc/odoo-bin  /opt/odoo/odoo-bin
ONBUILD COPY odoo-cc/odoo      /opt/odoo/odoo
# Load enterprise and community addons
ONBUILD COPY odoo-cc/addons    /opt/odoo/addons/90-odoo-cc
# Make files odoo's
ONBUILD RUN chown -R odoo:odoo /opt/odoo /var/lib/odoo

