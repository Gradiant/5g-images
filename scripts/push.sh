#!/bin/bash

REGISTRY=docker.io/gradiant

if [ -z "$IMAGE_LIST" ]; then
    LIST_CHANGED=`git diff --name-only main -- images | cut -f1-2 -d'/' | uniq`
else
    LIST_CHANGED=$IMAGE_LIST
fi

for image in $LIST_CHANGED; do
    pushd $image
    source image_info.sh
    IMAGE_NAME=${image#"images/"}
    if [ -z "$PLATFORMS" ]; then
      docker push $REGISTRY/$IMAGE_NAME:$IMAGE_TAG
    else
      docker buildx build -t $REGISTRY/$IMAGE_NAME:$IMAGE_TAG --build-arg version=$IMAGE_TAG --platform ${PLATFORMS} . --push
    fi
    popd
done