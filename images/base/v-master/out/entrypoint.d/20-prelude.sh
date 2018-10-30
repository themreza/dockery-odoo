#!/bin/bash

RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'

LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'


NC='\033[0m' # No Color


echo -en "${LBLUE}$(echo '''
H4sIAJ1D0lsAA4WP0Q3EIAxD/zOFB0DKAh0FKYt0+LPPXJr7apBMgi3gAUCxMKsqqMkd26a0Ellj
dBMKeikuVTApY9QKiYej3NbFDs78nPAzuVt5fNd9On6N3dKFL/W9Z8QeUBM61JjmcyzabbZBiB1t
/xG1Hr8R1sThn1gfro4ZK3sBAAA=
''' | base64 -d | gzip -d)${NC}"

echo -en """${LPURPLE}

Questions, bugs or feature requests?
   Submit here:  https://github.com/xoe-labs/dockery-odoo
   Join here:    https://t.me/joinchat/ILnVJw7s3ZvKL3mI7AACsw

${NC}"""

echo -en """

${LYELLOW}
                              Runtime Overview
==============================================
| ----------------------------------- Versions
| App:              ${ODOO_VERSION}
| Psql:             ${PSQL_VERSION}
| WkhtmltoX:        ${WKHTMLTOX_MINOR:=${WKHTMLTOX_VERSION}}
| Node:             ${NODE_VERSION:="n/a"}
| Bootstrap:        ${BOOTSTRAP_VERSION:="n/a"}
| ---------------------------- Files & Folders
| App Basepath:     ${ODOO_BASEPATH}
| App Cmd:          ${ODOO_CMD}
| Framework Path:   ${ODOO_FRM}
| Backup Dir:       ${ODOO_BCKP_DIR}
| Peristence Dir:   ${ODOO_PRST_DIR}
| Addons Basepath:  ${ODOO_ADDONS_BASEPATH}
| Addons Path:      ${ODOO_ADDONS_PATH//"${ODOO_ADDONS_BASEPATH}/"}
| Migration Spec:   ${ODOO_MIG}
| -------------------------------- Environment
| App UID:          ${APP_UID}
| App GID:          ${APP_GID}
| Current UID:      $(id -u)
| Current GID:      $(id -g)
| Serverpwd:        $(cat "${ODOO_PASSFILE:="."}" || true)
==============================================


${NC}"""
