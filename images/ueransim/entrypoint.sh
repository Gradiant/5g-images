#!/bin/bash

set -e

if [ $# -lt 1 ]
then
        echo "Usage : $0 [gnb|ue]"
        exit
fi

command=$1
shift

case "$command" in

ue) 
    GNB_IP=${GNB_IP:-"$(host -4 $GNB_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
    export GNB_IP
    echo "GNB_IP: $GNB_IP"
    envsubst < /etc/ueransim/ue.yaml > ue.yaml
    echo "Launching ue: nr-ue -c ue.yaml"
    nr-ue -c ue.yaml $@
    ;;
gnb)
    N2_BIND_IP=${N2_BIND_IP:-"$(ip addr show ${N2_IFACE}  | grep -o 'inet [[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}'| cut -c 6-)"}
    N3_BIND_IP=${N3_BIND_IP:-"$(ip addr show ${N3_IFACE} | grep -o 'inet [[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}'| cut -c 6-)"}
    RADIO_BIND_IP=${RADIO_BIND_IP:-"$(ip addr show ${RADIO_IFACE} | grep -o 'inet [[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}'| cut -c 6-)"}
    AMF_IP=${AMF_IP:-"$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
    export N2_BIND_IP N3_BIND_IP RADIO_BIND_IP AMF_IP
    echo "N2_BIND_IP: $N2_BIND_IP"
    echo "N3_BIND_IP: $N3_BIND_IP"
    echo "RADIO_BIND_IP: $RADIO_BIND_IP"
    echo "AMF_IP: $AMF_IP"
    envsubst < /etc/ueransim/gnb.yaml > gnb.yaml
    echo "Launching gnb: nr-gnb -c gnb.yaml"
    nr-gnb -c gnb.yaml $@
    ;;
*) echo "unknown component $1 is not a component (gnb or ue). Running $@ as command"
   $@
   ;;
esac
