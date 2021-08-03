FROM ubuntu:18.04 AS builder

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" 

ARG version=develop

ENV VERSION=$version
RUN apt-get update


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#install developers pkg/repo
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
       #gcc needed for build_oai
       build-essential \
       psmisc \
       git \
       xxd \
       #unzip is needed for protobuf
       unzip


#create the WORKDIR
WORKDIR /oai-ran
RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git . 
RUN git checkout $VERSION

#run build_oai -I to get the builder image
RUN /bin/sh oaienv && \ 
    cd cmake_targets && \
    mkdir -p log && \
    ./build_oai -I -w USRP

RUN /bin/sh oaienv && cd cmake_targets && ./build_oai --gNB -w USRP
RUN cd cmake_targets && ./build_oai --eNB -w USRP
RUN cd cmake_targets && ./build_oai --nrUE -w USRP
RUN cd cmake_targets && ./build_oai --UE -w USRP


#apt-get update && apt-get upgrade -y && apt-get install iputils-ping net-tools apt-utils -y && git checkout develop && git pull &&

#start from scratch for target executable
FROM ubuntu:bionic as oai-gnb
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        software-properties-common \
        libsctp1 \
        libnettle6 \
        libblas3 \
        libatlas3-base \
        libconfig9 \
		liblapacke \
		libusb-1.0-0 \
        openssl \
        net-tools \
        iproute2 \
        iputils-ping \
        libyaml-0-2 \
        gettext-base iproute2 dnsutils iputils-ping procps net-tools && \ 
    add-apt-repository ppa:ettusresearch/uhd --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        libuhd3.15.0 && \
    rm -rf /var/lib/apt/lists/*
   
ENV APP_ROOT=/opt/oai
COPY --from=builder /oai-ran/targets/bin/* ${APP_ROOT}/bin/

COPY --from=builder /oai-ran/targets/bin/*.so.* /usr/local/lib/
COPY --from=builder /oai-ran/cmake_targets/ran_build/build/*.so /usr/local/lib/
COPY --from=builder /usr/local/lib/libprotobuf-c.so.1 /usr/local/lib/


RUN rm /usr/local/lib/liboai_transpro.so && ln -s /usr/local/lib/liboai_eth_transpro.so.Rel15 /usr/local/lib/liboai_transpro.so && \
    rm /usr/local/lib/liboai_device.so && ln -s /usr/local/lib/liboai_usrpdevif.so.Rel15 /usr/local/lib/liboai_device.so && \
    rm /usr/local/lib/librfsimulator.so && ln -s /usr/local/lib/librfsimulator.so.Rel15 /usr/local/lib/librfsimulator.so && \
    ldconfig

COPY --from=builder /oai-ran/targets/PROJECTS/GENERIC-LTE-EPC/CONF/*.conf ${APP_ROOT}/etc/orig/generic-lte-epc/
COPY --from=builder /oai-ran/targets/PROJECTS/GENERIC-NR-5GC/CONF/*.conf ${APP_ROOT}/etc/orig/generic-nr-5gc/
COPY configs ${APP_ROOT}/etc/
COPY entrypoint.sh /

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

WORKDIR ${APP_ROOT}


ENV TEMPLATE_PATH=/opt/oai/etc/gnb.sa.band78.fr1.106PRB.usrpb210.conf.tpl \
    CTRL_BIND_INTERFACE=eth0 \
    DATA_BIND_INTERFACE=eth0 \
    MODE=SA \
    AMF_HOSTNAME=amf \
	MODE_SA=true \
    MCC=001 \
    MNC=01 \
    TAC=1



ENTRYPOINT ["/entrypoint.sh"]