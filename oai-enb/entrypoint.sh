#!/bin/bash

set -ex

#If not provided get IP_ADDR from interfaces
if [[ -z "${ENB_BIND_ADDR}" ]] ; then
    export ENB_BIND_ADDR=$(ip addr show $ENB_BIND_INTERFACE | grep -Po 'inet \K[\d.]+/\d+')
fi


# Resolve IP ADDRESS if hostname is provided
if [[ ! -z "$MME_HOSTNAME" ]] ; then 
    export MME_ADDR="$(host -4 $MME_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi


echo "Launching oai enb"
envsubst < $ENB_TEMPLATE_PATH > enb.conf
/opt/oai/bin/lte-softmodem -O enb.conf
