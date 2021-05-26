.PHONY: all build push

REGISTRY=docker.io
IMAGE=openverso/free5gc
TAG=3.0.5

build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . 

build-webui:
	docker build -t ${IMAGE}-webui:${TAG} --build-arg version=${TAG}  . -f Dockerfile.webui

push:
	echo "Pushing the images ${IMAGE} to ${REGISTRY}"; \
	echo "Insert credentials to registry: "; \
	docker --config=.docker login ${REGISTRY}; \
	docker tag ${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:${TAG}; \
	docker --config=.docker push ${REGISTRY}/${IMAGE}:${TAG}; \
	rm -r .docker

push-webui:
	echo "Pushing the image ${IMAGE}-webui to ${REGISTRY}"; \
	echo "Insert credentials to registry: "; \
	docker --config=.docker login ${REGISTRY}; \
	docker tag ${IMAGE}-webui:${TAG} ${REGISTRY}/${IMAGE}-webui:${TAG}; \
	docker --config=.docker push ${REGISTRY}/${IMAGE}-webui:${TAG}; \
	rm -r .docker

all: build push build-webui push-webui
