#!/bin/bash
set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        curl \
        xz-utils \
    && curl -SLo wkhtmltox.tar.xz https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && echo "0ef646d802cd0375524034d11af76444c7c8e796e11d553ab39bd4a7bf703ac631f4a3300902bec54589b3d5400b5762d9995839f6faaae2f9159efdf225cc78  wkhtmltox.tar.xz" | sha512sum -c - \
    && tar --strip-components 1 -C /usr/local/ -xf wkhtmltox.tar.xz \
    && rm wkhtmltox.tar.xz \
    && wkhtmltopdf --version \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove \
        curl \
        xz-utils
