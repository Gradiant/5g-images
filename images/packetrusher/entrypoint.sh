#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [ue | multi-ue -n N]"
        exit
fi

if [[ -z "${GNB_NGAP_ADDR}" ]] ; then
    export GNB_NGAP_ADDR=$(ip addr show $GNB_NGAP_DEV | grep -Po 'inet \K[\d.]+')
fi

if [[ -z "${GNB_GTPU_ADDR}" ]] ; then
    export GNB_GTPU_ADDR=$(ip addr show $GNB_GTPU_DEV | grep -Po 'inet \K[\d.]+')
fi

if [[ ! -z "$AMF_HOSTNAME" ]] ; then 
    export AMF_ADDR="$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

envsubst < config/config.yml > config.yml

./packetrusher --config config.yml $@