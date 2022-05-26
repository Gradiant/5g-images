FROM ubuntu:focal AS build

ARG version=2021.w32

ENV VERSION=$version

ARG NEEDED_GIT_PROXY
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

# In some network environments, GIT proxy is required
RUN /bin/bash -c "if [[ -v NEEDED_GIT_PROXY ]]; then git config --global http.proxy $NEEDED_GIT_PROXY; fi"

RUN apt-get update && apt-get install -y git
#create the WORKDIR
WORKDIR /oai-ran
RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git . 
RUN git checkout $VERSION


#run build_oai -I to get the builder image
RUN /bin/sh oaienv && \ 
    cd cmake_targets && \
    mkdir -p log && \
    ./build_oai -I -w USRP

#run build_oai to build the target image
RUN /bin/sh oaienv && \ 
    cd cmake_targets && \
    mkdir -p log && \
    ./build_oai --eNB --ninja -w USRP --verbose-ci



RUN apt-get install -y python3-pip && \
    pip3 install --ignore-installed pyyaml && \
    python3 ./docker/scripts/generateTemplate.py ./docker/scripts/enb_parameters.yaml
#run build_oai to build the target image
RUN /bin/sh oaienv && \ 
    cd cmake_targets && \
    ./build_oai --gNB --ninja -w USRP --verbose-ci
RUN python3 ./docker/scripts/generateTemplate.py ./docker/scripts/gnb_parameters.yaml

#run build_oai to build the target image
RUN /bin/sh oaienv && \ 
    cd cmake_targets && \
    mkdir -p log && \
    ./build_oai --nrUE --ninja -w USRP --verbose-ci
RUN cp ci-scripts/conf_files/nr-ue-sim.conf docker/etc

#start from scratch for target executable
FROM ubuntu:focal as oai
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        libsctp1 \
        procps \
        tzdata \
        libnettle7 \
        liblapacke \
        libblas3 \
        libatlas3-base \
        libconfig9 \
        libprotobuf-c1 \
        openssl \
        net-tools \
        dnsutils \
        iputils-ping \
        iproute2 \
        iperf \
        libyaml-0-2 \
        libsctp1 \
        software-properties-common && \
    # Install UHD driver from ettus
    add-apt-repository ppa:ettusresearch/uhd --yes && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        python \
        libusb-1.0-0 \
        libuhd4.2.0 \
        uhd-host && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /oai-ran/targets/bin/* /opt/oai/bin/
COPY --from=build /oai-ran/docker/scripts/*.sh /
COPY --from=build /oai-ran/targets/bin/*.so.Rel15 /usr/local/lib/
COPY --from=build /oai-ran/targets/bin/*.so /usr/local/lib/
COPY --from=build /oai-ran/cmake_targets/ran_build/build/*.so /usr/local/lib/

RUN /bin/bash -c "ln -sf /usr/local/lib/liboai_eth_transpro.so.Rel15 /usr/local/lib/liboai_transpro.so"
RUN /bin/bash -c "ln -sf /usr/local/lib/liboai_usrpdevif.so.Rel15 /usr/local/lib/liboai_device.so"
RUN /bin/bash -c "ln -sf /usr/local/lib/librfsimulator.so.Rel15 /usr/local/lib/librfsimulator.so"

RUN ldconfig

# Copy the relevant configuration files
COPY --from=build /oai-ran/docker/etc /opt/oai/etc

WORKDIR /opt/oai

#This is a patch to support IP extraction from interface names and host names
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

