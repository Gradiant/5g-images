FROM ubuntu:20.04 as builder

ARG version=20_04_1
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    git \
    build-essential \ 
    cmake \
    libfftw3-dev \
    libmbedtls-dev \
    libboost-program-options-dev \
    libconfig++-dev \
    libsctp-dev \
    libuhd-dev \
    libzmq3-dev

RUN	cd /opt && git clone https://github.com/srsran/srsRAN.git && \
	cd srsRAN && git checkout release_$VERSION && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/srsRAN/target ../ && \
    make

RUN cd /opt/srsRAN/build && make install 



FROM ubuntu:20.04

ARG version=20_04_1
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

COPY --from=builder /opt/srsRAN/target/ /usr/


# libraries
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    	libboost-program-options1.71.0 \
        libconfig++9v5 \
        libfftw3-single3 \ 
        libmbedtls12 \
        libsctp1 \
        libuhd3.15.0 \
        libzmq5 && \
    rm -rf /var/lib/apt/lists/*

#Tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    gettext-base iproute2 dnsutils curl iptables iputils-ping traceroute && \
    rm -rf /var/lib/apt/lists/*
     
COPY etc/srsran /etc/srsran

ENV ENB_ID=0x19B \
    MCC=001 \
    MNC=01 \
    TAC=0001 \
    GTP_BIND_INTERFACE=eth0 \
    S1C_BIND_INTERFACE=eth0 \
    MME_BIND_INTERFACE=eth0 \
    LOG_LEVEL=info \
    UE_HOSTNAME=ue \
    ENB_HOSTNAME=enodeb \
    MSISDN=0000000001 \
    KEY=465B5CE8B199B49FAA5F0A2EE238A6BC \
    OPC=E8ED289DEBA952E4283B54E88E6183CA 

ENV IPV4_TUN_SUBNET="10.45.0.0/16" \
    IPV4_TUN_ADDR="10.45.0.1" \
    ENABLE_NAT=true
#ENV MME_HOSTNAME=mme 
#ENV MME_ADDR=192.168.0.2

#zmq ports
EXPOSE 2000/tcp
EXPOSE 2001/tcp

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
