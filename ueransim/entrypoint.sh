#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [gnb|ue]"
        exit
fi

export AMF_ADDR="$(host -4 amf |awk '/has.*address/{print $NF; exit}')"
export GNB_ADDR="$(host -4 gnb |awk '/has.*address/{print $NF; exit}')"
command=$1
shift

case "$command" in

ue)  echo "Launching ue"
    envsubst < /etc/ueransim/open5gs-ue.yaml > open5gs-ue.yaml
    /root/UERANSIM/build/nr-ue -c open5gs-ue.yaml
    ;;
gnb)  echo "Launching gnb"
    envsubst < /etc/ueransim/open5gs-gnb.yaml > open5gs-gnb.yaml
    /root/UERANSIM/build/nr-gnb -c open5gs-gnb.yaml
    ;;
*) echo "unknown component $1. should be epc, enb or ue."
   ;;
esac

echo "Hi"