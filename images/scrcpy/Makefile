.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/scrcpy
TAG=1.12.1
PLATFORMS=linux/amd64,linux/arm64

build:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS}
push:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS} --push
