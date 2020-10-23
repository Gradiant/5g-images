#!/bin/bash

set -eo pipefail


# tun iface create
function tun_create {
    if ! grep "ogstun" /proc/net/dev > /dev/null; then
        echo "Creating ogstun device"
        ip tuntap add name ogstun mode tun
    fi
    ip addr del $IPV4_TUN_SUBNET dev ogstun 2> /dev/null || true
    ip addr add $IPV4_TUN_SUBNET dev ogstun;
    #ip addr del cafe::1/64 dev ogstun 2> /dev/null || true
    #ip addr add cafe::1/64 dev ogstun
    ip link set ogstun up
}
 
 COMMAND=$1
if [[ "$COMMAND"  == *"open5gs-pgwd" ]] || [[ "$COMMAND"  == *"open5gs-upfd" ]]; then
tun_create
fi

# Temporary patch to solve the case of docker internal dns not resolving "not running" container names.
# Just wait 10 seconds to be "running" and resolvable
if [[ "$COMMAND"  == *"open5gs-pcrfd" ]] || [[ "$COMMAND"  == *"open5gs-mmed" ]]; then
sleep 10
fi

$@

exit 1
