#!/bin/bash

set -euo pipefail

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
rm /config.conf || true

# grep variable names (format: ${VAR}) from template to be rendered
VARS=$(grep -oP '@[a-zA-Z0-9_]+@' ${CONFIG_TEMPLATE} | sort | uniq | xargs)

# create sed expressions for substituting each occurrence of ${VAR}
# with the value of the environment variable "VAR"
EXPRESSIONS=""
for v in ${VARS}; do
    NEW_VAR=`echo $v | sed -e "s#@##g"`
    if [[ "${!NEW_VAR}x" == "x" ]]; then
        echo "Error: Environment variable '${NEW_VAR}' is not set." \
            "Config file '$(basename ${CONFIG_TEMPLATE})' requires all of $VARS."
        exit 1
    fi
    EXPRESSIONS="${EXPRESSIONS};s|${v}|${!NEW_VAR}|g"
done
EXPRESSIONS="${EXPRESSIONS#';'}"

# render template and inline replace config file
sed -i "${EXPRESSIONS}" ${CONFIG_TEMPLATE}

# Load the USRP binaries
if [[ -v USE_B2XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t b2xx
elif [[ -v USE_X3XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t x3xx
elif [[ -v USE_N3XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t n3xx
fi

echo "=================================="
echo "== Starting gNB soft modem"
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
