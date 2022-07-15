#/bin/bash

REMOTE_FILE="https://github.com/open5gs/open5gs/raw/main/misc/db/open5gs-dbctl"


CURRENT_TAG=`wget -qO- https://github.com/open5gs/open5gs/raw/main/misc/db/open5gs-dbctl |grep version= | cut -d '=' -f2`

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
