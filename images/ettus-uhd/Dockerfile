FROM ubuntu:20.04

ARG version
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"


RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ettusresearch/uhd && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y \
    libuhd4.1.0 uhd-host && \
    rm -rf /var/lib/apt/lists/*

RUN mv  /usr/lib/uhd/examples/* /usr/local/bin/