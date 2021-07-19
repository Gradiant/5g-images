.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/ueransim
TAG=3.2.2

build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=v${TAG} . 

push:
	echo "Pushing the images ${IMAGE} to ${REGISTRY}"; \
	echo "Insert credentials to registry: "; \
	docker --config=.docker login ${REGISTRY}; \
	docker tag ${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:${TAG}; \
	docker --config=.docker push ${REGISTRY}/${IMAGE}:${TAG}; \
	rm -r .docker

all: build push
