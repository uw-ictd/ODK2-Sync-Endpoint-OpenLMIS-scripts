#!/bin/bash -u

set -o pipefail

IP=$(getent hosts ${SERVICE_NAME} | awk '{ print $1 }')

node registration.js -c register -f config.json -i ${IP}