.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/oai-enb
TAG=1.2.2

build:
	docker build -t ${IMAGE}:${TAG} . 
	docker build -t ${IMAGE}:${TAG}-uhd-images . -f Dockerfile.uhd_images

push:
	echo "Pushing the images ${IMAGE} to ${REGISTRY}"; \
	echo "Insert credentials to registry: "; \
	docker --config=.docker login ${REGISTRY}; \
	docker tag ${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:${TAG}; \
	docker --config=.docker push ${REGISTRY}/${IMAGE}:${TAG}; \
	docker tag ${IMAGE}:${TAG}-uhd-images ${REGISTRY}/${IMAGE}:${TAG}-uhd-images; \
	docker --config=.docker push ${REGISTRY}/${IMAGE}:${TAG}-uhd-images; \

	rm -r .docker

all: build push
