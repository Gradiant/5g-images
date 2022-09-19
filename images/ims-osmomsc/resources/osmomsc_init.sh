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

# Temporary patch to solve the case of docker internal dns not resolving "not running" container names.
# Just wait 10 seconds to be "running" and resolvable
sleep 10

OSMOMSC_IP=${OSMOMSC_IP:-"$(host -4 $OSMOMSC_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export OSMOMSC_IP
echo "OSMOMSC_IP: $OSMOMSC_IP"

OSMOHLR_IP=${OSMOHLR_IP:-"$(host -4 $OSMOHLR_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export OSMOHLR_IP
echo "OSMOHLR_IP: $OSMOHLR_IP"

if [ -z "$OSMOMSC_IP" ] \
    || [[ -z "$OSMOHLR_IP" ]]; then
echo "Unable to resolve some IPs... restarting"
exit 1
fi

[ ${#MNC} == 3 ] && 3GPP_REALM="mnc${MNC}.mcc${MCC}.3gppnetwork.org" || 3GPP_REALM="mnc0${MNC}.mcc${MCC}.3gppnetwork.org"

cp /mnt/osmomsc/osmo-msc.cfg /etc/osmocom

sed -i 's|OSMOMSC_IP|'$OSMOMSC_IP'|g' /etc/osmocom/osmo-msc.cfg
sed -i 's|OSMOHLR_IP|'$OSMOHLR_IP'|g' /etc/osmocom/osmo-msc.cfg
sed -i 's|MNC|'$MNC'|g' /etc/osmocom/osmo-msc.cfg
sed -i 's|MCC|'$MCC'|g' /etc/osmocom/osmo-msc.cfg
sed -i 's|3GPP_REALM|'$3GPP_REALM'|g' /etc/osmocom/osmo-msc.cfg

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
