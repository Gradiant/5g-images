FROM ubuntu:18.04

MAINTAINER Carlos Giraldo <cgiraldo@gradiant.org> 

ARG version=20_04_1

ENV VERSION=$version


RUN apt-get update && \
    apt-get install -y  \
    git \
    build-essential \ 
    cmake \
    libfftw3-dev \
    libmbedtls-dev \
    libboost-program-options-dev \
    libconfig++-dev \
    libsctp-dev \
    libzmq3-dev 

RUN	cd /tmp && git clone https://github.com/srsLTE/srsLTE.git && \
	cd srsLTE && git checkout release_$VERSION && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr ../ && \
    make

RUN cd /tmp/srsLTE/build && make install 

RUN apt-get install -y gettext-base iproute2 dnsutils curl iputils-ping traceroute

COPY /etc/srslte /etc/srslte

#zmq ports
EXPOSE 2000/tcp
EXPOSE 2001/tcp

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


COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
