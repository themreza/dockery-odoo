#!/bin/bash
set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        curl \
        git-all \
        openssh-client \
    && curl -sSL https://get.docker.com/ | sed 's/lxc-docker/lxc-docker-1.11/' | sh > /dev/null \
    && curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  > /dev/null \
    && chmod +x /usr/local/bin/docker-compose \
    && rm -rf /var/lib/apt/lists/*
