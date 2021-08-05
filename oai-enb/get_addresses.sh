#!/bin/bash

IFACES=${IFACES:-"ENB_S1C ENB_S1U ENB_X2"}
HOSTNAMES=${HOSTNAMES:-"MME_S1C "}

set -e

# Get IP address from iface names and export
for iface in $IFACES; do
    var1="${iface}_IP_ADDRESS"
    var2="${iface}_IF_NAME"
    if [ -z "${!var1}" ] && [ ! -z "${!var2}" ] ; then
        address=$(ip addr show ${!var2} | grep -Po 'inet \K[\d.]+')
        declare -x "$var1=$address"
        echo "$var1=$address"
    fi
done

# Resolve IP ADDRESS if hostname is provided
for hostname in $HOSTNAMES; do
    var1="${hostname}_IP_ADDRESS"
    var2="${hostname}_HOSTNAME"
    if [ -z "${!var1}" ] && [ ! -z "${!var2}" ] ; then
        echo "check if ${!var2} hostname is resolvable"
        host -4 ${!var2}
        address=$(host -4 ${!var2} |awk '/has.*address/{print $NF; exit}')
        declare -x "$var1=$address"
	    echo "$var1=$address"
    fi
done

echo "remove /opt/oai-enb/etc/enb.conf if exists"
rm /opt/oai-enb/etc/enb.conf || true

echo "$@"
exec "$@"
