FROM ubuntu:20.04 as builder

ARG version
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Álvaro Vázquez <avrodriguez@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    git \
    build-essential \
    cmake \
    make \ 
    gcc \ 
    g++ \ 
    pkg-config \ 
    libfftw3-dev \ 
    libmbedtls-dev \ 
    libsctp-dev \ 
    libyaml-cpp-dev \ 
    libgtest-dev \ 
    libzmq3-dev \
    libboost-program-options-dev \
    libconfig++-dev \
    libuhd-dev \
    uhd-host

RUN	cd /opt && git clone https://github.com/srsran/srsRAN_Project.git && \
	cd srsRAN_Project && git checkout release_$VERSION && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/srsRAN_Project/target -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON -DENABLE_AVX512=False ../ && \
    make

RUN cd /opt/srsRAN_Project/build && make install 

# Embed env variables in gnb.yml files
RUN cd /opt/srsRAN_Project/target/share/srsran && \
    sed -i '0,/addr:/{s/addr: .*/addr: ${AMF_ADDR}/}' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/bind_addr:.*/bind_addr: ${AMF_BIND_ADDR}/g' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/device_driver:.*/device_driver: ${DEVICE_DRIVER}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/device_args:.*/device_args: ${DEVICE_ARGS}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/srate:.*/srate: ${SRATE}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/tx_gain:.*/tx_gain: ${TX_GAIN}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/rx_gain:.*/rx_gain: ${RX_GAIN}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/dl_arfcn:.*/dl_arfcn: ${DL_ARFCN}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/band:.*/band: ${BAND}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/channel_bandwidth_MHz:.*/channel_bandwidth_MHz: ${BANDWIDTH}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/common_scs:.*/common_scs: ${SCS}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/plmn:.*/plmn: "${PLMN}"/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/tac:.*/tac: ${TAC}/' gnb_rf_b200_tdd_n78_20mhz.yml && \
    sed -i 's/pci:.*/pci: ${PCI}/' gnb_rf_b200_tdd_n78_20mhz.yml

FROM ubuntu:20.04

ARG version
ENV VERSION=$version
ENV UHD_IMAGES_DIR=/usr/share/uhd/images/

LABEL org.opencontainers.image.authors="Álvaro Vázquez <avrodriguez@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

# libraries
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
        software-properties-common \
    	libboost-program-options-dev \
        libzmq3-dev \
        libconfig++-dev \
        libfftw3-dev \ 
        libmbedtls-dev \
        libsctp-dev  \
        libyaml-cpp-dev \ 
        libgtest-dev \
        gettext-base \
        iproute2 \
        dnsutils \
        net-tools \
        curl \
        iptables \
        iputils-ping \
        traceroute && \
    # Install UHD driver from ettus
    add-apt-repository ppa:ettusresearch/uhd --yes && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        libuhd-dev \ 
        libuhd4.4.0 \
        uhd-host && \
    uhd_images_downloader && \
    rm -rf /var/lib/apt/lists/*


COPY --from=builder /opt/srsRAN_Project/target/bin/ /opt/srsRAN_Project/target/bin/
COPY --from=builder /opt/srsRAN_Project/target/share/srsran/ /opt/srsRAN_Project/target/share/srsran/
COPY --from=builder /opt/srsRAN_Project/target/lib/ /opt/srsRAN_Project/target/lib/
     
ENV AMF_HOSTNAME=amf \
    AMF_BIND_INTERFACE=eth0 \
    DEVICE_DRIVER=uhd \
    DEVICE_ARGS=type=b200,num_recv_frames=64,num_send_frames=64 \
    SRATE=23.04 \
    TX_GAIN=50 \
    RX_GAIN=60 \
    DL_ARFCN=632628 \
    BAND=78 \
    BANDWIDTH=20 \
    SCS=30 \
    PLMN=99970 \
    TAC=7 \
    PCI=1

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
