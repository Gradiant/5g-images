.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/open5gs
TAG=2.3.2
PLATFORMS=linux/amd64,linux/arm64

build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . 
	docker build -t ${IMAGE}-webui:${TAG} --build-arg version=${TAG}  . -f Dockerfile.webui


buildx:
	docker buildx build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform ${PLATFORMS} --push
	docker buildx build -t ${IMAGE}-webui:${TAG} --build-arg version=${TAG}  . -f Dockerfile.webui --platform ${PLATFORMS} --push
