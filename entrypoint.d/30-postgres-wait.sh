#!/bin/bash
log INFO --Waiting until postgres is listening at $PGHOST...
while true; do
    psql --list > /dev/null 2>&1 && break
    sleep 1
done
