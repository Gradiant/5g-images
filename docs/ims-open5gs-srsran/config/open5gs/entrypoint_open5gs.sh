#!/bin/bash

set -eo pipefail

# tun iface create
# function tun_create {
#     if ! grep "ogstun" /proc/net/dev > /dev/null; then
#         echo "Creating ogstun device"
#         ip tuntap add name ogstun mode tun
#     fi

#     ip addr del $IPV4_TUN_ADDR dev ogstun 2> /dev/null || true
#     ip addr add $IPV4_TUN_ADDR dev ogstun;

#     sysctl -w net.ipv6.conf.all.disable_ipv6=0;         
#     ip addr del $IPV6_TUN_ADDR dev ogstun 2> /dev/null || true
#     ip addr add $IPV6_TUN_ADDR dev ogstun
    
#     ip link set ogstun up
#     sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward";
#     if [ "$ENABLE_NAT" = true ] ; then
#       iptables -t nat -A POSTROUTING -s $IPV4_TUN_SUBNET ! -o ogstun -j MASQUERADE;
#     fi
# }

function tun_create {
    if ! grep "ogstun" /proc/net/dev > /dev/null; then
        echo "Creating ogstun device"
        ip tuntap add name ogstun mode tun
    fi

    ip addr del 192.168.100.0/24 dev ogstun 2> /dev/null || true
    ip addr add 192.168.100.0/24 dev ogstun;

    sysctl -w net.ipv6.conf.all.disable_ipv6=0;         
    ip addr del 2001:230:cafe::/48 dev ogstun 2> /dev/null || true
    ip addr add 2001:230:cafe::/48 dev ogstun
    
    ip link set ogstun up
    sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward";
    iptables -t nat -A POSTROUTING -s 192.168.100.0/24 ! -o ogstun -j MASQUERADE;

    if ! grep "ogstun2" /proc/net/dev > /dev/null; then
        echo "Creating ogstun2 device"
        ip tuntap add name ogstun2 mode tun
    fi

    ip addr del 192.168.101.0/24 dev ogstun2 2> /dev/null || true
    ip addr add 192.168.101.0/24 dev ogstun2;

    sysctl -w net.ipv6.conf.all.disable_ipv6=0;         
    ip addr del 2001:230:babe::/48 dev ogstun2 2> /dev/null || true
    ip addr add 2001:230:babe::/48 dev ogstun2
    
    ip link set ogstun2 up
    sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward";
}

# Set extra environment variables
export MNC=01
export MCC=001
export PCSCF_HOSTNAME=pcscf
 
 COMMAND=$1
if [[ "$COMMAND"  == *"open5gs-pgwd" ]] || [[ "$COMMAND"  == *"open5gs-upfd" ]]; then
echo "Running tun_if script"
tun_create
fi

# Temporary patch to solve the case of docker internal dns not resolving "not running" container names.
# Just wait 10 seconds to be "running" and resolvable
if [[ "$COMMAND"  == *"open5gs-pcrfd" ]] \
    || [[ "$COMMAND"  == *"open5gs-mmed" ]] \
    || [[ "$COMMAND"  == *"open5gs-sgwcd" ]] \
    || [[ "$COMMAND"  == *"open5gs-upfd" ]]; then
sleep 10
fi

if [[ "$COMMAND"  == *"open5gs-smfd" ]]; then
# Install extra packages needed
apt-get update && apt-get install -y dnsutils gettext-base

PCSCF_IP=${PCSCF_IP:-"$(host -4 $PCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export PCSCF_IP
echo "PCSCF_IP: $PCSCF_IP"

if [[ -z "$PCSCF_IP" ]]; then
echo "Unable to resolve some IPs... restarting"
exit 1
fi

envsubst < /opt/open5gs/smf.yaml > /opt/open5gs/etc/open5gs/smf.yaml

fi

$@

exit 1
