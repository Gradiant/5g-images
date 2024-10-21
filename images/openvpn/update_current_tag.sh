#!/bin/bash

set -x

CURRENT_TAG=$(curl -sSL https://dl-cdn.alpinelinux.org/alpine/v3.20/main/x86_64/ | grep "openvpn" | awk 'NR==2' | awk -F'[-]' '{print $2}')

# Load IMAGE_TAG
[[ -f image_info.sh ]] && source image_info.sh || exit 1


# Compare CURRENT_TAG with saved IMAGE_TAG
[[ ${CURRENT_TAG} == ${IMAGE_TAG} ]] || {
	echo "Updating old TAG ${IMAGE_TAG} with new TAG ${CURRENT_TAG}"
	sed -i "/IMAGE_TAG/s/=.*$/=${CURRENT_TAG}/" image_info.sh
	exit 0
} 

# Fail otherwise
exit 1
