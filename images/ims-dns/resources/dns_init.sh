#!/bin/bash

# BSD 2-Clause License

# Copyright (c) 2020, Supreeth Herle
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

DNS_IP=${DNS_IP:-"$(host -4 $DNS_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export DNS_IP
echo "DNS_IP: $DNS_IP"

PCRF_IP=${PCRF_IP:-"$(host -4 $PCRF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export PCRF_IP
echo "PCRF_IP: $PCRF_IP"

ICSCF_IP=${ICSCF_IP:-"$(host -4 $ICSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export ICSCF_IP
echo "ICSCF_IP: $ICSCF_IP"

SCSCF_IP=${SCSCF_IP:-"$(host -4 $SCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export SCSCF_IP
echo "SCSCF_IP: $SCSCF_IP"

PCSCF_IP=${PCSCF_IP:-"$(host -4 $PCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export PCSCF_IP
echo "PCSCF_IP: $PCSCF_IP"

FHOSS_IP=${FHOSS_IP:-"$(host -4 $FHOSS_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export FHOSS_IP
echo "FHOSS_IP: $FHOSS_IP"

SMSC_IP=${SMSC_IP:-"$(host -4 $SMSC_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export SMSC_IP
echo "SMSC_IP: $SMSC_IP"

if [ -z "$DNS_IP" ] \
    || [[ -z "$PCRF_IP" ]] \
    || [[ -z "$PCSCF_IP" ]] \
    || [[ -z "$FHOSS_IP" ]] \
    || [[ -z "$SMSC_IP" ]] \
    || [[ -z "$ICSCF_IP" ]] \
    || [[ -z "$SCSCF_IP" ]]; then
echo "Unable to resolve some IPs... restarting"
exit 1
fi

cp /mnt/dns/epc_zone /etc/bind
cp /mnt/dns/ims_zone /etc/bind
cp /mnt/dns/e164.arpa /etc/bind
cp /mnt/dns/named.conf /etc/bind

EPC_DOMAIN=$EPC_DOMAIN
IMS_DOMAIN=$IMS_DOMAIN

sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' /etc/bind/epc_zone
sed -i 's|DNS_IP|'$DNS_IP'|g' /etc/bind/epc_zone
[ -z "$PCRF_PUB_IP" ] && sed -i 's|PCRF_IP|'$PCRF_IP'|g' /etc/bind/epc_zone || sed -i 's|PCRF_IP|'$PCRF_PUB_IP'|g' /etc/bind/epc_zone

sed -i 's|IMS_DOMAIN|'$IMS_DOMAIN'|g' /etc/bind/ims_zone
sed -i 's|DNS_IP|'$DNS_IP'|g' /etc/bind/ims_zone
sed -i 's|PCSCF_IP|'$PCSCF_IP'|g' /etc/bind/ims_zone
sed -i 's|ICSCF_IP|'$ICSCF_IP'|g' /etc/bind/ims_zone
sed -i 's|SCSCF_IP|'$SCSCF_IP'|g' /etc/bind/ims_zone
sed -i 's|FHOSS_IP|'$FHOSS_IP'|g' /etc/bind/ims_zone
sed -i 's|SMSC_IP|'$SMSC_IP'|g' /etc/bind/ims_zone

sed -i 's|IMS_DOMAIN|'$IMS_DOMAIN'|g' /etc/bind/e164.arpa
sed -i 's|DNS_IP|'$DNS_IP'|g' /etc/bind/e164.arpa

sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' /etc/bind/named.conf
sed -i 's|IMS_DOMAIN|'$IMS_DOMAIN'|g' /etc/bind/named.conf

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
