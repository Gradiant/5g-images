FROM ubuntu:18.04

ARG version=v3.1.0

ENV VERSION=$version

RUN apt-get update && \
    apt-get install -y  \
    git \
    build-essential \ 
    snapd \
    libfftw3-dev \
    libmbedtls-dev \
    libboost-program-options-dev \
    libconfig++-dev \
    libsctp-dev \
    libzmq3-dev 

RUN	cd ~ && git clone https://github.com/aligungr/UERANSIM.git && \
    cd UERANSIM && git checkout tags/$VERSION 

RUN apt-get update && \
    apt-get install -y  \
    make \
    g++ \
    libsctp-dev \
    lksctp-tools \
    iproute2 \
    wget \
    tar \
    libsctp-dev \ 
    gettext-base \
    dnsutils \
    libssl-dev 

RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3.tar.gz && \
    tar -zxvf cmake-3.17.3.tar.gz && \ 
    cd cmake-3.17.3 && \
    ./bootstrap && \
    make && \
    make install

RUN file="$(cmake --version)" && echo $file
RUN cd ~/UERANSIM && echo "cmake --version" && make

COPY /etc/ueransim /etc/ueransim

ENV ENB_ID=0x19B \
    MCC=001 \
    MNC=01 \
    TAC=0001 \
    GTP_BIND_INTERFACE=eth0 \
    S1C_BIND_INTERFACE=eth0 \
    UE_HOSTNAME=ue \
    ENB_HOSTNAME=enodeb
#ENV MME_HOSTNAME=mme 
#ENV MME_ADDR=192.168.0.2

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["/bin/bash"]

