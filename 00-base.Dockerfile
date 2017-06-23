FROM debian:jessie
USER root

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
ADD build/00-grab-gosu.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# grab apt-https support
ADD build/01-grab-apt-https-support.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# grab system libraries
ADD build/10-grap-odoo-system-libraries.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# grab postgres-client-9.5
ADD build/11-grab-postgres-client-9.5.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# grab wkhtmltopdf
ADD build/12-grab-wkhtmltopdf-0.12.4.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# grab web stack / Install node 6.x less, sass & phantomjs
ADD build/13-grab-web-stack.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# grab web stack / Install node 6.x less, sass & phantomjs
ADD build/14-grab-locales.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# Add odoo user and var/lib/odoo, ownership
ADD build/20-create-user-and-var-lib-odoo.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# Grab gettext
ADD build/21-grab-gettext.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# grab odoo pip requirements
ADD build/30-base-requirements-txt.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# Grab geoip
ADD build/31-grab-geoip.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

# Grab ptpython for odoo shell, did not work: bpython and ipython
ADD build/32-grab-ptpython-for-odoo-shell.sh /tmp/command
RUN chmod +x /tmp/command && sync && /tmp/command

COPY bin/* /usr/local/bin/
COPY lib/* /usr/local/lib/python2.7/dist-packages/odoo-docker-base-libs/
ENV PATH=$PATH:/usr/local/lib/python2.7/dist-packages/odoo-docker-base-libs
RUN chmod +x -R /usr/local/bin/ /usr/local/lib/python2.7/dist-packages/

COPY entrypoint.d /home/entrypoint.d
COPY config.d /home/config.d
RUN chmod +x -R /home

ENTRYPOINT ["entrypoint.sh", "/opt/odoo/odoo-bin"]
VOLUME ["/var/lib/odoo"]
