#!/bin/bash

set -e

if [ $# -lt 1 ]
then
        echo "Usage : $0 [gnb|ue]"
        exit
fi

command=$1

case "$command" in

ue)  echo "Launching ue: nr-ue -c ue.yaml"
    if [[ ! -z "${GNB_HOSTNAME}" ]] ; then
        export GNB_ADDR="$(host -4 $GNB_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    fi
    envsubst < /etc/ueransim/ue.yaml > ue.yaml
    nr-ue -c ue.yaml
    ;;
gnb)  echo "Launching gnb: nr-gnb -c gnb.yaml"
    if [[ ! -z "${UE_HOSTNAME}" ]] ; then
        export GNB_ADDR="$(host -4 $GNB_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    fi
    if [[ ! -z "${AMF_HOSTNAME}" ]] ; then
        export AMF_ADDR="$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    fi

    envsubst < /etc/ueransim/gnb.yaml > gnb.yaml
    nr-gnb -c gnb.yaml
    ;;
*) echo "unknown component $1 is not a component (gnb or ue). Running $@ as command"
   $@
   ;;
esac
