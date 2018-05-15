FROM debian:jessie AS base-build

USER root

ENV ODOO_VERSION 10.0
ENV PSQL_VERSION 10
ENV WKHTMLTOX_VERSION 0.12
ENV WKHTMLTOX_MINOR 0.12.4
ENV NODE_VERSION 6
ENV BOOTSTRAP_VERSION 3.3.7

# Build Time Deps
RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	bzip2 \
	curl \
	libgeoip-dev \
	python-dev \
	wget \
	xz-utils \
	# lxml
	libxml2-dev \
	libxslt1-dev\
	# Pillow
	libjpeg-dev \
	libfreetype6-dev \
    liblcms2-dev \
    libopenjpeg-dev \
    libtiff5-dev \
    tk-dev \
    tcl-dev \
 	# psutil
	linux-headers-amd64 \
	# psycopg2
	libpq-dev \
	# python-ldap
	libldap2-dev \
	libsasl2-dev

# Odoo Run Time Deps
RUN apt-get update && apt-get install -y --no-install-recommends \
	python \
	apt-transport-https \
	ca-certificates \
	locales \
	fontconfig \
	libfreetype6 \
	libjpeg62-turbo \
	liblcms2-2 \
	libldap-2.4-2 \
	libopenjpeg5 \
	libpq5 \
	libsasl2-2 \
	libtiff5 \
	libx11-6 \
	libxext6 \
	libxml2 \
	libxrender1 \
	libxslt1.1 \
	tcl \
	tk \
	zlib1g \
	zlibc

# Grab latest pip
RUN curl https://bootstrap.pypa.io/get-pip.py | python /dev/stdin --no-cache-dir

# Get Odoo pip dependencies
RUN pip install --no-cache-dir --requirement https://raw.githubusercontent.com/odoo/odoo/${ODOO_VERSION}/requirements.txt
RUN pip install --no-cache-dir psutil==4.3.1 pydot==1.2.3 ofxparse==0.16

# Grab Postgres
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' >> /etc/apt/sources.list.d/postgresql.list
RUN curl -SL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
RUN apt-get update && apt-get install -y --no-install-recommends \
        postgresql-client-${PSQL_VERSION}

# Grab wkhtmltopdf
RUN curl -SLo wkhtmltox.tar.xz https://downloads.wkhtmltopdf.org/${WKHTMLTOX_VERSION}/${WKHTMLTOX_MINOR}/wkhtmltox-${WKHTMLTOX_MINOR}_linux-generic-amd64.tar.xz
RUN echo "0ef646d802cd0375524034d11af76444c7c8e796e11d553ab39bd4a7bf703ac631f4a3300902bec54589b3d5400b5762d9995839f6faaae2f9159efdf225cc78  wkhtmltox.tar.xz" | sha512sum -c -
RUN tar --strip-components 1 -C /usr/local/ -xf wkhtmltox.tar.xz
RUN rm wkhtmltox.tar.xz && wkhtmltopdf --version

# Go get Web Stack
RUN echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x jessie main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_${NODE_VERSION}.x jessie main" >> /etc/apt/sources.list.d/nodesource.list
RUN curl -SL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN apt-get update && apt-get install -y --no-install-recommends \
        gem \
        nodejs \
        ruby-compass
RUN ln -s /usr/bin/nodejs /usr/local/bin/node
RUN npm install -g less
RUN gem install --no-rdoc --no-ri --no-update-sources bootstrap-sass --version "${BOOTSTRAP_VERSION}"
RUN rm -Rf ~/.gem /var/lib/gems/*/cache/
RUN rm -Rf ~/.npm /tmp/*

# Add geoip database
RUN wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
RUN gunzip GeoLiteCity.dat.gz
RUN mkdir -p /usr/share/GeoIP
RUN mv GeoLiteCity.dat /usr/share/GeoIP/
RUN pip install GeoIP

# Improve Odoo shell, in case we need it once
RUN pip install ptpython

# Install json log formatter (for non-tty use)
RUN pip install python-json-logger


# Read configs and secrets
# UID & GID will be used to fix secrets permission on docker-compose bind mounted ("plain") secrets
ENV PGPASSFILE=/run/secrets/pgpass ODOO_RC=/run/configs/odoo.d APP_UID=9001 APP_GID=9001 PGHOST=db

# Create Odoo User
RUN addgroup --system --gid $APP_UID odoo
RUN adduser --system --uid $APP_GID --ingroup odoo --home /opt/odoo --disabled-login --shell /sbin/nologin odoo

# Copy helpers
COPY bin/* /usr/local/bin/
COPY lib/* /usr/local/lib/python2.7/dist-packages/dockery-odoo-libs/
COPY entrypoint.sh /
COPY entrypoint.d /entrypoint.d
COPY patches.d /patches.d
ENV PATH=$PATH:/usr/local/lib/python2.7/dist-packages/dockery-odoo-libs

# Make secrets folder editable to work arround docker-compose mock implementation
ENV BACKUP_DIR /var/lib/odoo-backups
ENV PERSISTENCE_DIR /var/lib/odoo-persist
RUN mkdir -p "${PERSISTENCE_DIR}" /run/secrets "${BACKUP_DIR}"
RUN chown -R odoo:odoo "${PERSISTENCE_DIR}" /run/secrets "${BACKUP_DIR}"

ENTRYPOINT ["/entrypoint.sh"]
VOLUME ["${PERSISTENCE_DIR}", "${BACKUP_DIR}"]

# Fix locale setting (needed for some tests to work)
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

USER odoo

# ============================================================
# Forward enforce minimal naming scheme on secondary build
# ============================================================

FROM base-build
ENV ODOO_BASEPATH="/opt/odoo"
ONBUILD COPY --chown=odoo:odoo 	vendor/odoo/cc/odoo-bin 	"${ODOO_BASEPATH}"/odoo-bin
ONBUILD COPY --chown=odoo:odoo 	vendor/odoo/cc/odoo  		"${ODOO_BASEPATH}"/odoo
ONBUILD COPY --chown=odoo:odoo 	vendor/odoo/cc/addons 		"${ODOO_BASEPATH}"/addons/000
ONBUILD COPY --chown=odoo:odoo 	vendor/odoo/ee 		 		"${ODOO_BASEPATH}"/addons/001
ONBUILD COPY --chown=odoo:odoo 	src 		 				"${ODOO_BASEPATH}"/addons/090
ONBUILD RUN apply-patches

# ============================================================