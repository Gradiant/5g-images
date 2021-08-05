#!/bin/bash

set -eo pipefail

PREFIX=/opt/oai-enb

IFACES=${IFACES:-"ENB_S1C ENB_S1U ENB_X2"}
HOSTNAMES=${HOSTNAMES:-"MME_S1C "}
CONFIG_TEMPLATE=

# Get IP address from iface names and export
for iface in $IFACES; do
    var1="${iface}_IP_ADDRESS"
    var2="${iface}_IF_NAME"
    if [ -z "${!var1}" ] && [ ! -z "${!var2}" ] ; then
        address=$(ip addr show ${!var2} | grep -Po 'inet \K[\d.]+/\d+')
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

echo "config.conf if exists"
rm $PREFIX/etc/enb.conf || true

RRC_INACTIVITY_THRESHOLD=${RRC_INACTIVITY_THRESHOLD:-0}

# Based another env var, pick one template to use
if [[ -v USE_FDD_CU ]]; then ln -s $PREFIX/etc/cu.fdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_FDD_DU ]]; then ln -s $PREFIX/etc/du.fdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_FDD_MONO ]]; then ln -s $PREFIX/etc/enb.fdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_TDD_MONO ]]; then ln -s $PREFIX/etc/enb.tdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_FDD_FAPI_RCC ]]; then ln -s $PREFIX/etc/rcc.nfapi.fdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_FDD_IF4P5_RCC ]]; then ln -s $PREFIX/etc/rcc.if4p5.fdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_TDD_IF4P5_RCC ]]; then ln -s $PREFIX/etc/rcc.if4p5.tdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_FDD_RRU ]]; then ln -s $PREFIX/etc/rru.fdd.conf $PREFIX/etc/enb.conf; fi
if [[ -v USE_TDD_RRU ]]; then ln -s $PREFIX/etc/rru.tdd.conf $PREFIX/etc/enb.conf; fi

# Only this template will be manipulated
CONFIG_FILES=`ls $PREFIX/etc/enb.conf || true`

for c in ${CONFIG_FILES}; do
    # grep variable names (format: ${VAR}) from template to be rendered
    VARS=$(grep -oP '@[a-zA-Z0-9_]+@' ${c} | sort | uniq | xargs)

    # create sed expressions for substituting each occurrence of ${VAR}
    # with the value of the environment variable "VAR"
    EXPRESSIONS=""
    for v in ${VARS}; do
        NEW_VAR=`echo $v | sed -e "s#@##g"`
        echo $NEW_VAR
        if [[ "${!NEW_VAR}x" == "x" ]]; then
            echo "Error: Environment variable '${NEW_VAR}' is not set." \
                "Config file '$(basename $c)' requires all of $VARS."
            exit 1
        fi
        EXPRESSIONS="${EXPRESSIONS};s|${v}|${!NEW_VAR}|g"
    done
    EXPRESSIONS="${EXPRESSIONS#';'}"

    # render template and inline replace config file
    sed -i "${EXPRESSIONS}" ${c}
done

# Load the USRP binaries
if [[ -v USE_B2XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t b2xx
elif [[ -v USE_X3XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t x3xx
elif [[ -v USE_N3XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t n3xx
fi

echo "=================================="
echo "== Starting eNB soft modem"
if [[ -v USE_ADDITIONAL_OPTIONS ]]; then
    echo "Additional option(s): ${USE_ADDITIONAL_OPTIONS}"
    new_args=()
    while [[ $# -gt 0 ]]; do
        new_args+=("$1")
        shift
    done
    for word in ${USE_ADDITIONAL_OPTIONS}; do
        new_args+=("$word")
    done
    echo "${new_args[@]}"
    exec "${new_args[@]}"
else
    echo "$@"
    exec "$@"
fi
