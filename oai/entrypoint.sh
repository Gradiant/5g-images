#!/bin/bash

set -eo pipefail

if [ "$#" -eq 0 ]; then
  echo "run with a command (docker run oai CMD)"
  echo ""
  echo "example of commands:"
  echo "  - /opt/oai/bin/lte-softmodem.Rel15 -O /oai.conf"
  echo "  - /opt/oai/bin/nr-softmodem.Rel15 -O /oai.conf"
  echo "  - /bin/bash"
  echo ""
  echo "This image provides predefined config templates. To choose a template, set CONFIG_TEMPLATE variable to:"
  echo "  - gnb_nsa_tdd_mono"
  echo "  - gnb_sa_tdd_mono"
  echo "  - enb_fdd_cu"
  echo "  - enb_fdd_du"
  echo "  - enb_fdd_mono"
  echo "  - enb_tdd_mono"
  echo "  - enb_fdd_fapi_rcc"
  echo "  - enb_fdd_if4p5_rcc"
  echo "  - enb_tdd_if4p5_rcc"
  echo "  - enb_fdd_rru"
  echo "  - enb_tdd_rru"
  echo "/oai.conf is generated from the template replacing '@VAR@' placeholders with environment variable values."
  echo "You can also mount your own template and provide the path with CONFIG_TEMPLATE_PATH environment variable."
  echo ""
  echo "Set USE_B2XX, USE_X3XX or USE_N3XX to load the USRP binaries."
  exit 1
fi

PREFIX=/opt/oai
ENABLE_X2=${ENABLE_X2:-yes}
RRC_INACTIVITY_THRESHOLD=${RRC_INACTIVITY_THRESHOLD:-0}
ENABLE_MEASUREMENT_REPORTS=${ENABLE_MEASUREMENT_REPORTS:-no}

# Get IP address of interfaces for env vars ending in _IF_NAME
for IFNAME_VAR in $(compgen -A variable | grep _IF_NAME); do
    ADDRESS_VAR="${IFNAME_VAR%_IF_NAME}_IP_ADDRESS"
    if [ -z "${!ADDRESS_VAR}" ]  ; then
        address=$(ip addr show ${!IFNAME_VAR} | grep -Po 'inet \K[\d.]+/\d+')
        declare -x "$ADDRESS_VAR=$address"
        echo "$ADDRESS_VAR=$address"
    fi
done

# Resolve IP ADDRESS for env vars ending in _HOSTNAME
for HOSTNAME_VAR in $(compgen -A variable | grep _HOSTNAME); do
    ADDRESS_VAR="${HOSTNAME_VAR%_HOSTNAME}_IP_ADDRESS"
    if [ -z "${!ADDRESS_VAR}" ] ; then
        echo "check if ${!HOSTNAME_VAR} hostname is resolvable"
        host -4 ${!HOSTNAME_VAR}
        address=$(host -4 ${!HOSTNAME_VAR} |awk '/has.*address/{print $NF; exit}')
        declare -x "$ADDRESS_VAR=$address"
        echo "$ADDRESS_VAR=$address"
    fi
done

# Based another env var, pick one template to use
if [ "$CONFIG_TEMPLATE" == "gnb_nsa_tdd_mono" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/gnb.nsa.tdd.conf";
elif [ "$CONFIG_TEMPLATE" == "gnb_sa_tdd_mono" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/gnb.sa.tdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_fdd_cu" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/cu.fdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_fdd_du" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/du.fdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_fdd_mono" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/enb.fdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_tdd_mono" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/enb.tdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_fdd_fapi_rcc" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/rcc.nfapi.fdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_fdd_if4p5_rcc" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/rcc.if4p5.fdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_tdd_if4p5_rcc" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/rcc.if4p5.tdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_fdd_rru" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/rru.fdd.conf";
elif [ "$CONFIG_TEMPLATE" == "enb_tdd_rru" ]; then
    CONFIG_TEMPLATE_PATH="$PREFIX/etc/rru.tdd.conf";
fi

if [[ ! -z "$CONFIG_TEMPLATE_PATH" ]]; then 

    # grep variable names (format: ${VAR}) from template to be rendered
    VARS=$(grep -oP '@[a-zA-Z0-9_]+@' ${CONFIG_TEMPLATE_PATH} | sort | uniq | xargs)

    # create sed expressions for substituting each occurrence of ${VAR}
    # with the value of the environment variable "VAR"
    EXPRESSIONS=""
    for v in ${VARS}; do
        NEW_VAR=`echo $v | sed -e "s#@##g"`
        if [[ "${!NEW_VAR}x" == "x" ]]; then
            echo "Error: Environment variable '${NEW_VAR}' is not set." \
                "Config file '$(basename ${CONFIG_TEMPLATE_PATH})' requires all of $VARS."
            exit 1
        fi
        EXPRESSIONS="${EXPRESSIONS};s|${v}|${!NEW_VAR}|g"
    done 
    EXPRESSIONS="${EXPRESSIONS#';'}"

    # render template 
    sed "${EXPRESSIONS}" ${CONFIG_TEMPLATE_PATH} > /oai.conf
fi

# Load the USRP binaries
if [[ -v USE_B2XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t b2xx
elif [[ -v USE_X3XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t x3xx
elif [[ -v USE_N3XX ]]; then
    /usr/lib/uhd/utils/uhd_images_downloader.py -t n3xx
fi


echo "$@"
exec "$@"


