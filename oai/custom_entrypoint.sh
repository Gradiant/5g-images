#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [ue|enb|nr-ue|gnb]"
        exit
fi

#If not provided get IP_ADDR from interfaces
if [[ -z "${CTRL_BIND_ADDR}" ]] ; then
    export CTRL_BIND_ADDR=$(ip addr show $CTRL_BIND_INTERFACE | grep -Po 'inet \K[\d.]+/\d+')
fi
if [[ -z "${DATA_BIND_ADDR}" ]] ; then
    export DATA_BIND_ADDR=$(ip addr show $DATA_BIND_INTERFACE | grep -Po 'inet \K[\d.]+/\d+')
fi

command=$1

case "$command" in
ue)
    BINARY="${BINARY-/opt/oai/bin/lte-uesoftmodem.Rel15}"
    CONFIG_TEMPLATE="${CONFIG_TEMPLATE:-/opt/oai/etc/ue.conf.tpl}"
    echo "ue not yet integrated. Run it manually"
    exit 0
    ;;
enb)
    BINARY="${BINARY-/opt/oai/bin/lte-softmodem.Rel15}"
    CONFIG_TEMPLATE="${CONFIG_TEMPLATE:-/opt/oai/etc/enb.band7.tm1.25PRB.b210.conf.tpl}"
    # Resolve IP ADDRESS if hostname is provided
    if [[ ! -z "$MME_HOSTNAME" ]] ; then 
        export MME_ADDR="$(host -4 $MME_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    fi
    ;;
nr-ue)
    BINARY="${BINARY-/opt/oai/bin/nr-uesoftmodem.Rel15}"
    CONFIG_TEMPLATE="${CONFIG_TEMPLATE:-/opt/oai/etc/nrue.conf.tpl}"
    echo "nr-ue not yet integrated. Run it manually"
    exit 0
    ;;
gnb)
    BINARY="${BINARY-/opt/oai/bin/nr-softmodem.Rel15}"
    CONFIG_TEMPLATE="${CONFIG_TEMPLATE:-/opt/oai/etc/gnb.sa.band78.fr1.106PRB.usrpb210.conf.tpl}"
    # Resolve IP ADDRESS if hostname is provided
    if [ "$MODE" == "SA" ] ; then
      ARGS="$ARGS --sa"
    fi
    if [[ ! -z "$AMF_HOSTNAME" ]] ; then 
        export AMF_ADDR="$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    fi
    ;;
*) echo "unknown component $1 is not a component (gnb or ue). Running $@ as command"
   $@
   exit 0
   ;;
esac


echo "Launching $BINARY with CONFIG_TEMPLATE: $CONFIG_TEMPLATE"
envsubst < $CONFIG_TEMPLATE > config.conf
$BINARY -O config.conf $ARGS
