.PHONY: all build push

all: build push

REGISTRY ?= harbor.cloudrenzo.gradiant.org/openverso
IMAGE=srs-lte
TAG=20_04_1


build:
	docker build -t ${IMAGE}:${TAG} .

push:
	echo "Insert credentials to registry: "; \
	docker login ${REGISTRY}; \
	docker tag ${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:${TAG}; \
	docker push ${REGISTRY}/${IMAGE}:${TAG}; \
	echo "WARNING: credentials are stored in your local docker configuration. execute docker logout ${REGISTRY} if you want to remove it."
