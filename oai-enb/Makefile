.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/oai-enb
TAG=2021.w28
PLATFORMS=linux/amd64
#PLATFORMS=linux/amd64,linux/arm64

build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} -f Dockerfile.enodeb . --platform ${PLATFORMS} --push