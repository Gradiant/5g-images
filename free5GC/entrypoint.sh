#!/bin/bash

set -eo pipefail

NF_LIST="nrf amf smf udr pcf upf udm nssf ausf"

COMMAND=$1
for NF in ${NF_LIST}; do
    if [[ "$COMMAND"  == NF ]]; then
        break
    else
        sleep 0.1
    fi
done
$@

exit 1

