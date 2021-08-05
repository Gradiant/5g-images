.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/open5gs
TAG=2.3.0

build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform linux/amd64,linux/arm64 --push
	docker build -t ${IMAGE}-webui:${TAG} --build-arg version=${TAG}  . -f Dockerfile.webui --platform linux/amd64,linux/arm64 --push
