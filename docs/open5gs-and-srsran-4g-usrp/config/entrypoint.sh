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
    ip link set srs_spgw_sgi up
    sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
    if [ "$ENABLE_NAT" = true ] ; then
      iptables -t nat -A POSTROUTING -s $IPV4_TUN_SUBNET ! -o srs_spgw_sgi -j MASQUERADE
    fi
}

# IP address resolution from interfaces or hostnames
if [[ -z "${GTP_BIND_ADDR}" ]] ; then
    export GTP_BIND_ADDR=$(ip addr show $GTP_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi
if [[ -z "${S1C_BIND_ADDR}" ]] ; then
    export S1C_BIND_ADDR=$(ip addr show $S1C_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi
if [[ -z "${MME_BIND_ADDR}" ]] ; then
    export MME_BIND_ADDR=$(ip addr show $MME_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi
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
    epc)
        echo "Launching srsepc"
        tun_create
        envsubst < /etc/srsran/epc.conf > epc.conf
        /bin/srsepc /epc.conf $@
        ;;
    enb)
        echo "Launching srsenb"
        envsubst < /etc/srsran/enb.conf > enb.conf
        if [ "$ZMQ" = true ] ; then
            sed -i 's/#device_name = zmq/device_name = zmq\ndevice_args = tx_port=tcp:\/\/*:2000,rx_port=tcp:\/\/${UE_ADDRESS}:2001,id=enb,base_srate=23.04e6/' enb.conf
            envsubst < enb.conf > enb_temp.conf
            mv enb_temp.conf enb.conf
        fi
        envsubst < /etc/srsran/rr.conf > rr.conf
        /bin/srsenb enb.conf $@
        ;;
    ue)
        echo "Launching srsue"
        
        envsubst < /etc/srsran/ue.conf > ue.conf
        if [ "$SRSUE_5G" = true ] ; then
            sed -i 's/#device_name = zmq/device_name = zmq\ndevice_args = tx_port=tcp:\/\/${UE_ADDRESS}:2001,rx_port=tcp:\/\/${ENB_ADDRESS}:2000,id=ue,base_srate=23.04e6/' ue.conf
            sed -i 's/^dl_earfcn =.*/dl_earfcn = ${DL_EARFCN}/' ue.conf
            sed -i 's/^# bands = .*/bands = ${BANDS}/' ue.conf
            sed -i 's/^#apn =.*/apn = ${APN}/' ue.conf
            sed -i 's/^#apn_protocol =.*/apn_protocol = ${APN_PROTOCOL}/' ue.conf
            sed -i 's/^#srate =.*/srate = ${SRATE}e6/' ue.conf
            sed -i 's/^#rx_gain =.*/rx_gain = ${RX_GAIN}/' ue.conf
            sed -i 's/^tx_gain =.*/tx_gain = ${TX_GAIN}/' ue.conf
            sed -E -i '/^\[rat\.eutra\]/{n;n;s/^#nof_carriers = .*/nof_carriers = ${EUTRA_NOF_CARRIERS}/}' ue.conf
            sed -E -i '/^\[rat\.nr\]/{n;n;s/^# nof_carriers = .*/nof_carriers = ${NR_NOF_CARRIERS}/}' ue.conf
            sed -i '/\[rat.nr\]/a\max_nof_prb = ${NR_MAX_NOF_PRB}' ue.conf
            sed -i '/\[rat.nr\]/a\nof_prb = ${NR_NOF_PRB}' ue.conf
            
        elif [ "$ZMQ" = true ] ; then
            sed -i 's/#device_name = zmq/device_name = zmq\ndevice_args = tx_port=tcp:\/\/${UE_ADDRESS}:2001,rx_port=tcp:\/\/${ENB_ADDRESS}:2000,id=ue,base_srate=23.04e6/' ue.conf
            
        fi
        envsubst < ue.conf > ue_temp.conf
        mv ue_temp.conf ue.conf
        /bin/srsue ue.conf $@
        ;;
    *)
        echo "unknown component $1. should be epc, enb or ue."
        ;;
esac
