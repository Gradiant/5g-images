#!/bin/bash

set -ex


source variables.env
if [ -z ${PLATFORM} ]; then
    docker build --pull --tag $IMAGE:$VERSION --build-arg version=$VERSION ..
else
    docker buildx build --load --pull --tag $IMAGE:$VERSION --build-arg version=$VERSION ..
    docker buildx build --platform $PLATFORM --pull --tag $IMAGE:$VERSION --build-arg version=$VERSION ..
fi
