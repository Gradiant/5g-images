.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/oai
TAG=2021.w48
PLATFORMS=linux/amd64#,linux/arm64

build:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS}
push:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS} --push
