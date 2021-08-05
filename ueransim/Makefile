.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/ueransim
TAG=3.2.1

build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . --platform linux/amd64,linux/arm64 --push
