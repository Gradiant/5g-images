FROM golang:1.14 as builder

ARG version=3.0.6
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

RUN cd /tmp/free5gc && \ 
    make upf
RUN cp /tmp/free5gc/NFs/upf/build/bin/free5gc-upfd /tmp/free5gc/bin/upf && \
    cp /tmp/free5gc/NFs/upf/build/config/upfcfg.yaml /tmp/free5gc/config/

RUN mkdir -p /tmp/free5gc/lib && \
    cp -rP /tmp/free5gc/NFs/upf/build/updk/src/third_party/libgtp5gnl/lib/libgtp5gnl.so* /tmp/free5gc/lib/ && \
    cp /tmp/free5gc/NFs/upf/build/utlt_logger/liblogger.so /tmp/free5gc/lib/



FROM debian:stable-slim

ARG version=3.0.6
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    libyaml-0-2 \
    libmnl0 \
    iproute2 iputils-ping procps net-tools iptables && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/free5gc/bin/ /usr/local/bin/
COPY --from=builder /tmp/free5gc/lib/ /lib/x86_64-linux-gnu/
COPY --from=builder /tmp/free5gc/config/ /etc/free5gc/


