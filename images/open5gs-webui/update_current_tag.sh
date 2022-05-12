#/bin/bash

REMOTE_REPO_URL="https://api.github.com/repos/open5gs/open5gs/git/refs/tags/"

GH="https://api.github.*"
GL="https://gitlab.*"

# Fetch the last version available on the remote repository
if [[ ${REMOTE_REPO_URL} =~ ${GH} ]] ; then
	CURRENT_TAG=$( curl -sSL ${REMOTE_REPO_URL} | sed -n '/v[0-9.]\+/h; $g; s/^.*\/v\([0-9.]\+\).*$/\1/; $p' )
# sed explanation
# -n dont print anything
# /v[0-9.]\+/h; every match with "v[0-9.]\+" gets stored on hold
# $g; replace contents of pattern space with hold space, adds last match as last line to buffer
# s//\1/; replace pattern, removes everything around version
# $p only last line is printed
elif [[ ${REMOTE_REPO_URL} =~ ${GL} ]] ; then
	CURRENT_TAG=$( curl -sSL ${REMOTE_REPO_URL} | jq -r '.[].name' | sed -n '1p' )
else
	echo "Error Reading URL"
	exit 1
fi

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
