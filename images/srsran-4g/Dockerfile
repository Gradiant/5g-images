FROM ubuntu:20.04 AS builder

ARG version
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

RUN	cd /opt && git clone https://github.com/srsran/srsRAN_4G.git && \
	cd srsRAN_4G && git checkout release_$VERSION && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/srsRAN_4G/target ../ && \
    make

RUN cd /opt/srsRAN_4G/build && make install 

# Move configuration
RUN mkdir -p /opt/srsRAN_4G/target/etc/srsran && \
    cd /opt/srsRAN_4G/target/share/srsran/ && find  -name '*.example' | while read f; do mv "$f" "/opt/srsRAN_4G/target/etc/srsran/${f%.example}"; done

# Embed env variables in enb.conf files
RUN cd /opt/srsRAN_4G/target/etc/srsran && \
    sed -i 's/^enb_id =.*/enb_id = ${ENB_ID}/' enb.conf && \
    sed -i 's/^mcc =.*/mcc = ${MCC}/' enb.conf && \
    sed -i 's/^mnc =.*/mnc = ${MNC}/' enb.conf && \
    sed -i 's/^mme_addr =.*/mme_addr = ${MME_ADDR}/' enb.conf && \
    sed -i 's/^gtp_bind_addr =.*/gtp_bind_addr = ${GTP_BIND_ADDR}/' enb.conf && \
    sed -i 's/^s1c_bind_addr =.*/s1c_bind_addr = ${S1C_BIND_ADDR}/' enb.conf && \
    sed -i 's/^n_prb =.*/n_prb = ${N_PRB}/' enb.conf && \
    sed -i 's/^tx_gain =.*/tx_gain = ${TX_GAIN}/' enb.conf && \
    sed -i 's/^rx_gain =.*/rx_gain = ${RX_GAIN}/' enb.conf

# Embed env variables in rr.conf files
RUN cd /opt/srsRAN_4G/target/etc/srsran && \
    sed -i 's/tac =.*/tac = ${TAC}/' rr.conf

# Embed env variables in ue.conf files
RUN cd /opt/srsRAN_4G/target/etc/srsran && \
    sed -E -i 's/^algo +=.*/algo = ${ALGO}/' ue.conf && \
    sed -E -i 's/^#?opc +=.*/opc = ${OPC}/' ue.conf && \
    sed -E -i 's/^k +=.*/k = ${KEY}/' ue.conf && \
    sed -i 's/^imsi =.*/imsi = ${MCC}${MNC}${MSISDN}/' ue.conf

# Embed env variables in epc.conf files
RUN cd /opt/srsRAN_4G/target/etc/srsran && \
    sed -i 's/^tac =.*/tac = ${TAC}/' epc.conf && \
    sed -i 's/^mcc =.*/mcc = ${MCC}/' epc.conf && \
    sed -i 's/^mnc =.*/mnc = ${MNC}/' epc.conf && \
    sed -i 's/^mme_bind_addr =.*/mme_bind_addr = ${MME_BIND_ADDR}/' epc.conf && \
    sed -i 's/^gtpu_bind_addr =.*/gtpu_bind_addr = ${MME_BIND_ADDR}/' epc.conf && \
    sed -i 's/^sgi_if_name =.*/sgi_if_name = ${IPV4_TUN_ADDR}/' epc.conf


FROM ubuntu:20.04

ARG version
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

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

COPY --from=builder /opt/srsRAN_4G/target/bin/* /usr/bin/
COPY --from=builder /opt/srsRAN_4G/target/etc/srsran/* /etc/srsran/
COPY --from=builder /opt/srsRAN_4G/target/include/ /usr/include/
COPY --from=builder /opt/srsRAN_4G/target/lib/ /usr/lib/

#Tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    gettext-base iproute2 dnsutils curl iptables iputils-ping traceroute && \
    rm -rf /var/lib/apt/lists/*
     
ENV ENB_ID=0x19B \
    MCC=001 \
    MNC=01 \
    TAC=0001 \
    N_PRB=50 \
    TX_GAIN=80 \
    RX_GAIN=40 \
    GTP_BIND_INTERFACE=eth0 \
    S1C_BIND_INTERFACE=eth0 \
    MME_BIND_INTERFACE=eth0 \
    LOG_LEVEL=info \
    UE_HOSTNAME=ue \
    ENB_HOSTNAME=enodeb \
    MSISDN=0000000001 \
    ALGO=mil \
    KEY=465B5CE8B199B49FAA5F0A2EE238A6BC \
    OPC=E8ED289DEBA952E4283B54E88E6183CA 

ENV IPV4_TUN_SUBNET="10.45.0.0/16" \
    IPV4_TUN_ADDR="10.45.0.1" \
    ENABLE_NAT=true

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
