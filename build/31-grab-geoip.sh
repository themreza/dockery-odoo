#!/bin/bash
# GeoIP is used for country detection on web interactions like chat or website sales
set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        wget python-dev build-essential libgeoip-dev\
    && wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
    && gunzip GeoLiteCity.dat.gz \
    && mkdir -p /usr/local/share/GeoIP \
    && mv GeoLiteCity.dat /usr/local/share/GeoIP/ \
    && rm -rf /var/lib/apt/lists/* \
    && pip install GeoIP \
    && apt-get purge -y --auto-remove \
        wget python-dev build-essential libgeoip-dev
