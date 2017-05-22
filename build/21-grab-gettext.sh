#!/bin/bash
# gettext used vor envsubst command during config file construction
set -x \
    && apt-get update && apt-get install -y --no-install-recommends gettext-base \
    && rm -rf /var/lib/apt/lists/*
