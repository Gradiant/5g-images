.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/free5gc
TAG=3.0.6
PLATFORMS=linux/amd64,linux/arm64

build:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS}
push:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS} --push

