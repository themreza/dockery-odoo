#!/bin/bash
set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        bzip2 \
        curl \
    && echo 'deb https://deb.nodesource.com/node_6.x jessie main' > /etc/apt/sources.list.d/nodesource.list \
    && echo 'deb-src https://deb.nodesource.com/node_6.x jessie main' >> /etc/apt/sources.list.d/nodesource.list \
    && curl -SL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && apt-get update && apt-get install -y --no-install-recommends \
        gem \
        nodejs \
        ruby-compass \
    && ln -s /usr/bin/nodejs /usr/local/bin/node \
    && npm install -g less \
    && gem install --no-rdoc --no-ri --no-update-sources bootstrap-sass --version '<4' \
    && npm install -g phantomjs-prebuilt \
    && rm -Rf ~/.gem /var/lib/gems/*/cache/ \
    && rm -Rf ~/.npm /tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove \
        bzip2 \
        curl \
        gem \
    && rm /etc/apt/sources.list.d/nodesource.list
