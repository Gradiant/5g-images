ARG version=4.3.0

FROM --platform=$BUILDPLATFORM golang:1.26-trixie AS builder

ARG version
WORKDIR /src/free5gc

RUN git clone --depth 1 --branch "v${version}" --recurse-submodules=NFs --shallow-submodules \
        https://github.com/free5gc/free5gc.git .

ARG TARGETOS
ARG TARGETARCH
RUN GOOS="$TARGETOS" GOARCH="$TARGETARCH" GOTOOLCHAIN=local make -j2 nfs

FROM debian:trixie-slim

ARG version
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates iproute2 iputils-ping iptables net-tools procps && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/free5gc/bin/ /usr/local/bin/
COPY --from=builder /src/free5gc/config/ /etc/free5gc/
COPY --from=builder /src/free5gc/LICENSE /src/free5gc/THIRD-PARTY-NOTICES.txt /usr/share/doc/free5gc/
