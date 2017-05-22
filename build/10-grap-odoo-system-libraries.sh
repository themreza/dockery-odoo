#!/bin/bash
set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        curl \
        python \
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
        zlibc \
    && curl https://bootstrap.pypa.io/get-pip.py | python /dev/stdin --no-cache-dir \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove \
        curl
