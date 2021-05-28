FROM golang:1.14 as builder

ARG version=3.0.5
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"


RUN apt-get update && \
    apt -y install \
        git gcc cmake autoconf libtool pkg-config libmnl-dev libyaml-dev

RUN go get -u github.com/sirupsen/logrus

RUN mkdir -p /tmp && cd /tmp && \
    git clone --recursive -b v$VERSION -j `nproc` https://github.com/free5gc/free5gc.git && \
    cd free5gc && \ 
    make

FROM debian:buster-slim

COPY --from=builder /tmp/free5gc/bin/ /usr/local/bin/
COPY  config/ /etc/free5gc/