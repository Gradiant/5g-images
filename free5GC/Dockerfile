FROM debian:buster-slim as builder

ARG version=2.0.18
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        apt-utils \
        git \
        curl \
        wget \
        systemd \
        ca-certificates \
        gnupg2 \
        gcc \
        build-essential \
        cmake \
        autoconf \
        automake \
        libtool \
        pkg-config \
        libmnl-dev \
        libyaml-dev \
        apt-transport-https \
        make && \
    apt-get clean

RUN apt-get update && \
    apt-get -y upgrade && \
    wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -zxvf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz && \
    bash -c "mkdir -p /go/{src,bin}"

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y nodejs yarn

RUN mkdir -p /tmp && cd /tmp && \
    git clone --recursive -b v3.0.5 -j `nproc` https://github.com/free5gc/free5gc.git && \
    cd free5gc && \
    make

RUN echo $(ls /var/lib/apt/lists/)

FROM debian:buster-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    libyaml-0-2 \
    libmnl0 \
    libmongoc-1.0-0 \
    libsctp1 \
    libidn11 \
    libcurl4 \
    libmicrohttpd12 \
    libnghttp2-14 \
    gettext-base \
    iproute2 iputils-ping procps net-tools iptables && \
    rm -rf /var/lib/apt/lists/*

ENV APP_ROOT=/opt/free5gc
COPY --from=builder /tmp/free5gc/bin ${APP_ROOT}/bin/
COPY config/ ${APP_ROOT}/config/
COPY --from=builder /tmp/free5gc/NFs/upf/build/bin ${APP_ROOT}/bin/
COPY --from=builder /tmp/free5gc/NFs/upf/build/updk/src/third_party/libgtp5gnl/lib/libgtp5gnl.so.0 /usr/local/lib
COPY --from=builder /tmp/free5gc/NFs/upf/build/utlt_logger/liblogger.so /usr/local/lib

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
WORKDIR ${APP_ROOT}

RUN ldconfig
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
