#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [epc|enb|ue]"
        exit
fi

# epc tun iface create
function tun_create {
    if ! grep "srs_spgw_sgi" /proc/net/dev > /dev/null; then
        echo "Creating srs_spgw_sgi device"
        ip tuntap add name srs_spgw_sgi mode tun
    fi
    # ip is set by srsepc
    #ip addr del $IPV4_TUN_ADDR dev srs_spgw_sgi 2> /dev/null || true
    #ip addr add $IPV4_TUN_ADDR dev srs_spgw_sgi;
    
    ip link set srs_spgw_sgi up
    sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward";
    if [ "$ENABLE_NAT" = true ] ; then
      iptables -t nat -A POSTROUTING -s $IPV4_TUN_SUBNET ! -o srs_spgw_sgi -j MASQUERADE;
    fi
}
 
#If not provided get IP_ADDR from interfaces
if [[ -z "${GTP_BIND_ADDR}" ]] ; then
    export GTP_BIND_ADDR=$(ip addr show $GTP_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi

if [[ -z "${S1C_BIND_ADDR}" ]] ; then
    export S1C_BIND_ADDR=$(ip addr show $S1C_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi

if [[ -z "${MME_BIND_ADDR}" ]] ; then
    export MME_BIND_ADDR=$(ip addr show $MME_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi

# Resolve IP ADDRESS if hostname is provided
if [[ ! -z "$MME_HOSTNAME" ]] ; then 
    export MME_ADDR="$(host -4 $MME_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ ! -z "$ENB_HOSTNAME" ]] ; then 
    export ENB_ADDRESS="$(host -4 $ENB_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi
if [[ ! -z "$UE_HOSTNAME" ]] ; then 
    export UE_ADDRESS="$(host -4 $UE_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

command=$1
shift

case "$command" in

epc)  echo "Launching srsepc"
    tun_create
    envsubst < /etc/srsran/epc.conf > epc.conf
    /usr/bin/srsepc /epc.conf $@
    ;;
enb)  echo "Launching srsenb"
    envsubst < /etc/srsran/enb.conf > enb.conf
    envsubst < /etc/srsran/rr.conf > rr.conf
    /usr/bin/srsenb enb.conf $@
    ;;
ue)   echo "Launching srsue"
    envsubst < /etc/srsran/ue.conf > ue.conf
    /usr/bin/srsue /ue.conf $@
    ;;
*) echo "unknown component $1. should be epc, enb or ue."
   ;;
esac
