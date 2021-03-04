FROM debian:latest as builder

ARG version=v3.1.0

ENV VERSION=$version

RUN apt-get update && \
    apt-get install -y  \
    git \
    make \
    wget \
    g++ \
    libssl-dev \
    libsctp-dev 
    
# requires cmake >=3.17
RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3.tar.gz && \
    tar -zxvf cmake-3.17.3.tar.gz && \ 
    cd cmake-3.17.3 && \
    ./bootstrap && \
    make && \
    make install

RUN file="$(cmake --version)" && echo $file


RUN cd /tmp && git clone https://github.com/aligungr/UERANSIM.git && \
    cd UERANSIM && git checkout tags/$VERSION 
RUN cd /tmp/UERANSIM && echo "cmake --version" && make

FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y  \
    curl \
    dnsutils \
    gettext-base \
    iproute2 \
    iputils-ping \
    libsctp1 \
    traceroute  && \
    rm -rf /var/lib/apt/lists/*

    
COPY --from=builder /tmp/UERANSIM/build/* /usr/local/bin/


COPY /etc/ueransim /etc/ueransim
COPY entrypoint.sh /entrypoint.sh

ENV ENB_ID=0x19B \
    MCC=001 \
    MNC=01 \
    TAC=0001 \
    MSISDN=0000000001 \
    SST=1 \
    SD=1 \
    GTP_BIND_INTERFACE=eth0 \
    S1C_BIND_INTERFACE=eth0 \
    UE_HOSTNAME=ue \
    GNB_HOSTNAME=gnb \
    AMF_HOSTNAME=amf

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]


