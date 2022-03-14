#!/bin/bash

default_branch=main
images_dir=images

list_changed=`git diff --name-only $default_branch -- $images_dir | cut -f1-2 -d'/' | uniq`

for image in $list_changed; do
    pushd $image
    source image_info.sh
    if [ -z "$PLATFORMS" ]; then
      docker build -t $image:$IMAGE_TAG --build-arg version=$IMAGE_TAG .
    else
      docker buildx build -t $image:$IMAGE_TAG --build-arg version=$IMAGE_TAG --platform ${PLATFORMS} .
    fi
    popd
done
