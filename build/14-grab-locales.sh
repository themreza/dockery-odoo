#!/bin/bash
set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        locales \
    && rm /etc/apt/sources.list.d/nodesource.list
