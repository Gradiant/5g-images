#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [gnb]"
        exit
fi

if [[ ! -z "$AMF_HOSTNAME" ]] ; then 
    export AMF_ADDR="$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ -z "${AMF_BIND_ADDR}" ]] ; then
    export AMF_BIND_ADDR=$(ip addr show $AMF_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi

envsubst < /opt/srsRAN_Project/target/share/srsran/gnb_rf_b200_tdd_n78_20mhz.yml > gnb.yml
/opt/srsRAN_Project/target/bin/gnb -c gnb.yml
