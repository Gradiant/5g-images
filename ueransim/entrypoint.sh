#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [gnb|ue]"
        exit
fi
if [ -n "${AMF_HOSTNAME}" ] ; then
    export AMF_ADDR="$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi
if [ -n "${GNB_HOSTNAME}" ] ; then
    export GNB_ADDR="$(host -4 $GNB_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

command=$1
shift

case "$command" in

ue)  echo "Launching ue"
    envsubst < /etc/ueransim/ue.yaml > ue.yaml
    /root/UERANSIM/build/nr-ue -c ue.yaml
    ;;
gnb)  echo "Launching gnb"
    envsubst < /etc/ueransim/gnb.yaml > gnb.yaml
    /root/UERANSIM/build/nr-gnb -c gnb.yaml
    ;;
*) echo "unknown component $1. should be gnb or ue."
   ;;
esac
