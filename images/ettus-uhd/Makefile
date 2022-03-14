.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/ettus-uhd
TAG=4.1.0
PLATFORMS=linux/amd64#,linux/arm64

build:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS}
	docker buildx build -t ${IMAGE}:${TAG}-uhd-images --build-arg version=${TAG} . -f Dockerfile.uhd_images --platform ${PLATFORMS}

push:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS} --push
	docker buildx build -t ${IMAGE}:${TAG}-uhd-images --build-arg version=${TAG} . --platform ${PLATFORMS} --push
