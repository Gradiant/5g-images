REGISTRY=docker.io
IMAGE=openverso/ueransim
TAG=3.2.6
PLATFORMS=linux/amd64#,linux/arm64

build:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS} --load
push:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS} --push
