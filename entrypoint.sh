#!/usr/bin/env bash

set -e

# Install custom python package if requirements.txt is present in app home directory
if [ -e "/app/requirements.txt" ]; then
    $(which pip) install --user -r /app/requirements.txt
fi

exec "$@"

