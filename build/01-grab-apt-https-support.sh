#!/bin/bash
set -x \
    && apt-get update && apt-get install -y --no-install-recommends apt-transport-https ca-certificates \
    && rm -rf /var/lib/apt/lists/*
