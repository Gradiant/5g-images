#!/bin/bash

set -ex

source variables.env

docker login $REGISTRY -u $REGISTRY_USER -p $REGISTRY_PASSWORD
if [ -z ${PLATFORM} ]; then
    docker tag $IMAGE:$VERSION $REGISTRY/$IMAGE:$VERSION
    docker push $IMAGE:$VERSION $REGISTRY/$IMAGE:$VERSION
else
    docker buildx build --push --platform $PLATFORM --pull --tag $REGISTRY/$IMAGE:$VERSION --build-arg version=$VERSION ..
fi

