FROM ubuntu:20.04

ENV version=3.15.0

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update &&\
    apt-get install -y \
        libuhd-dev \
        libuhd3.15.0 \
        uhd-host && \
    rm -rf /var/lib/apt/lists/*

RUN mv  /usr/lib/uhd/examples/* /usr/local/bin/