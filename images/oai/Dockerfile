FROM ubuntu:focal AS build

ARG version
ENV VERSION=$version

ARG BUILD_OPTION
ARG NEEDED_GIT_PROXY
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe
ENV BUILD_UHD_FROM_SOURCE=True
ENV UHD_VERSION=4.4.0.0
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
       unzip \
       # python3-pip for conf template generation
       python3-pip && \
    pip3 install --ignore-installed pyyaml

# In some network environments, GIT proxy is required
RUN /bin/bash -c "if [[ -v NEEDED_GIT_PROXY ]]; then git config --global http.proxy $NEEDED_GIT_PROXY; fi"

#create the WORKDIR
WORKDIR /oai-ran
RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git . 
RUN git checkout $VERSION

#run build_oai -I to get the builder image
RUN /bin/sh oaienv && \ 
    cd cmake_targets && \
    mkdir -p log && \
    ./build_oai -I -w USRP --install-optional-packages

#run build_oai to build the target image
RUN /bin/sh oaienv && \ 
    cd cmake_targets && \
    mkdir -p log && \
    ./build_oai -c --ninja \
    --eNB --gNB --RU --UE --nrUE \
    --build-lib "telnetsrv enbscope uescope nrscope" \
    -w USRP -t Ethernet \
    --build-e2 --cmake-opt -DXAPP_MULTILANGUAGE=OFF \
    --noavx512 \
    --cmake-opt -DCMAKE_C_FLAGS=-Werror --cmake-opt -DCMAKE_CXX_FLAGS=-Werror $BUILD_OPTION && \
    # Mainly to see if the sanitize option was perfectly executed
    ldd ran_build/build/nr-softmodem

#start from scratch for target executable
FROM ubuntu:focal AS oai
ARG BUILD_OPTION
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        software-properties-common \
        tzdata \
        procps \
        libsctp1 \
        liblapacke \
        libblas3 \
        libatlas3-base \
        libconfig9 \
        openssl \
        net-tools \
        iperf3 \
        iputils-ping \
        iproute2 \
        dnsutils \
        gdb \
        python \
        python3 \
        python3-six \
        python3-requests \
        libusb-1.0-0 && \
    /bin/bash -c 'if [[ "$BUILD_OPTION" = "--sanitize" ]]; then DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        libasan5 \
        libubsan1 \
        liblapacke; fi' && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build \ 
    /oai-ran/cmake_targets/ran_build/build/*softmodem \
    /oai-ran/cmake_targets/ran_build/build/oairu \ 
    /oai-ran/cmake_targets/nas_sim_tools/build/conf2uedata \
    /oai-ran/cmake_targets/nas_sim_tools/build/nvram \
    /oai-ran/cmake_targets/nas_sim_tools/build/usim \
    /oai-ran/cmake_targets/ran_build/build/nr-cuup \
    /opt/oai/bin/
COPY --from=build /oai-ran/docker/scripts/*.sh /
COPY --from=build /oai-ran/cmake_targets/ran_build/build/*.so /usr/local/lib/

COPY --from=build /usr/local/bin/uhd_find_devices /usr/local/bin
COPY --from=build /usr/local/lib/libuhd.so.4.4.0 /usr/local/lib
COPY --from=build /usr/local/lib/uhd/utils/uhd_images_downloader.py /opt/oai/bin
COPY --from=build \
    /usr/lib/x86_64-linux-gnu/libboost_chrono.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/libboost_date_time.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/libboost_regex.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/libboost_serialization.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/libboost_system.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.71.0 \
    /usr/lib/x86_64-linux-gnu/

RUN cd /opt/oai/bin && \
    ln -s nr-softmodem nr-softmodem.Rel15 && \
    ln -s lte-softmodem lte-softmodem.Rel15 && \
    ln -s lte-uesoftmodem lte-uesoftmodem.Rel15 && \
    ln -s nr-uesoftmodem nr-uesoftmodem.Rel15 && \
    ldconfig

WORKDIR /opt/oai

#This is a patch to support IP extraction from interface names and host names
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

