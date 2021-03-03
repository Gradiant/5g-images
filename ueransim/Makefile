.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/ueransim
TAG=v3.1.0

build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . 

push:
	echo "Pushing the images ${IMAGE} to ${REGISTRY}"; \
	echo "Insert credentials to registry: "; \
	docker --config=.docker login ${REGISTRY}; \
	docker tag ${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:${TAG}; \
	docker --config=.docker push ${REGISTRY}/${IMAGE}:${TAG}; \
	rm -r .docker

all: build push