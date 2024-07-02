#!/bin/bash

set -e

_term() { 
    case "$command" in
    ue) 
        echo "Deleting ue: nr-ue -c ue.yaml"
        for x in $(./usr/local/bin/nr-cli -d); do 
            ./usr/local/bin/nr-cli $x --exec "deregister switch-off"
        done
        echo "UEs switched off"
        sleep 5
        ;;
    *) 
        echo "It isn't necessary to perform any cleanup"
        ;;
    esac
}

if [ $# -lt 1 ]
then
        echo "Usage : $0 [gnb|ue]"
        exit
fi

command=$1
trap _term SIGTERM
shift

case "$command" in

ue) 
    GNB_IP=${GNB_IP:-"$(host -4 $GNB_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
    export GNB_IP
    echo "GNB_IP: $GNB_IP"
    envsubst < /etc/ueransim/ue.yaml > ue.yaml
    echo "Launching ue: nr-ue -c ue.yaml"
    nr-ue -c ue.yaml $@ &
    child=$!
    wait "$child"
    ;;
gnb)
    N2_BIND_IP=${N2_BIND_IP:-"$(ip addr show ${N2_IFACE}  | grep -o 'inet [[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}'| cut -c 6-)"}
    N3_BIND_IP=${N3_BIND_IP:-"$(ip addr show ${N3_IFACE} | grep -o 'inet [[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}'| cut -c 6-)"}
    N3_ADVERTISE_IP=${N3_ADVERTISE_IP:-"$N3_BIND_IP"}
    RADIO_BIND_IP=${RADIO_BIND_IP:-"$(ip addr show ${RADIO_IFACE} | grep -o 'inet [[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}'| cut -c 6-)"}
    AMF_IP=${AMF_IP:-"$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
    RADIO_BIND_IP=${RADIO_BIND_IP:-"$(ip addr show ${RADIO_IFACE} | grep -o 'inet [[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}'| cut -c 6-)"}
    export N2_BIND_IP N3_BIND_IP RADIO_BIND_IP AMF_IP N3_ADVERTISE_IP
    echo "N2_BIND_IP: $N2_BIND_IP"
    echo "N3_BIND_IP: $N3_BIND_IP"
    echo "N3_ADVERTISE_IP: $N3_ADVERTISE_IP"
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
