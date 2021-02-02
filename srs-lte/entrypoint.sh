#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [epc|enb|ue]"
        exit
fi

#If not provided get IP_ADDR from interfaces
if [[ -z "${GTP_BIND_ADDR}" ]] ; then
    export GTP_BIND_ADDR=$(ip addr show $GTP_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi

if [[ -z "${S1C_BIND_ADDR}" ]] ; then
    export S1C_BIND_ADDR=$(ip addr show $S1C_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi

# Resolve IP ADDRESS if hostname is provided
if [[ ! -z "$MME_HOSTNAME" ]] ; then 
    export MME_ADDR="$(host -4 $MME_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

command=$1
shift

case "$command" in

epc)  echo "Launching srsepc"
    envsubst < /etc/srslte/epc.conf > epc.conf
    /usr/bin/srsepc /epc.conf $@
    ;;
enb)  echo "Launching srsenb"
    envsubst < /etc/srslte/enb.conf > enb.conf
    envsubst < /etc/srslte/rr.conf > rr.conf
    /usr/bin/srsenb enb.conf $@
    ;;
ue)   echo "Launching srsue"
    envsubst < /etc/srslte/ue.conf > ue.conf
    /usr/bin/srsue /ue.conf $@
    ;;
*) echo "unknown component $1. should be epc, enb or ue."
   ;;
esac
