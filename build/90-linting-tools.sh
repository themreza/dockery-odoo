#!/bin/bash
set -x \
    && pip install --upgrade --pre pylint-odoo \
    && pip install pylint-mccabe coverage
