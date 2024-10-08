#!/bin/bash

set -x

CURRENT_TAG=$(docker run --pull=always -ti --rm alpine:latest apk info --no-cache openvpn | grep -Po '(?<=openvpn-)[\d\.]+' | head -1)

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
