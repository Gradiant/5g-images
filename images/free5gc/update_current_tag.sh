#!/bin/bash
set -euo pipefail

source image_info.sh

release=$(curl -fsSL https://api.github.com/repos/free5gc/free5gc/releases/latest)
tag=$(jq -er '.tag_name | select(test("^v[0-9]+[.][0-9]+[.][0-9]+$"))' <<< "$release")
version=${tag#v}

if [[ $version == "$IMAGE_TAG" ]]; then
    exit 0
fi

echo "Updating free5GC from $IMAGE_TAG to $version"
sed -i "s/^IMAGE_TAG=.*/IMAGE_TAG=$version/" image_info.sh
