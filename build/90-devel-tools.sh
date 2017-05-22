#!/bin/bash
set -x \
    && apt-get update && apt-get install -y --no-install-recommends build-essential python-dev \
    && pip install \
        astor \
        ptpython \
        pudb \
        pyinotify \
        watchdog \
        wdb \
    && rm -rf /var/lib/apt/lists/*
