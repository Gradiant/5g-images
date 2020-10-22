FROM ubuntu:20.04 as builder

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" 

ARG version=1.2.2

ENV VERSION=$version
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    libtasn1-6-dev \
    libgnutls28-dev \
    iproute2 \
    libconfig-dev \
	autoconf  \
	automake  \
	bison  \
	build-essential \
	cmake \
	#cmake-curses-gui  \
	#doxygen \
	#doxygen-gui \
	#texlive-latex-base \
	ethtool \
	flex  \
	#gdb  \
	git \
	#graphviz \
	#gtkwave \
	guile-2.0-dev \
	iperf \
	iptables \
	libatlas-base-dev \
	libblas-dev \
    libdouble-conversion-dev \
    liblapack-dev \
    liblapacke-dev \
	libffi-dev \
	libforms-bin \
	libforms-dev \
	libgcrypt20-dev \
	libgmp-dev \
    libgoogle-glog-dev \
    libgflags-dev \
	#libgtk-3-dev \
	libidn2-0-dev  \
	libidn11-dev \
	libmysqlclient-dev  \
    libprotobuf-dev  \
    libprotobuf-c-dev  \
	libpython2.7-dev \
	libsctp1  \
	libsctp-dev  \
	libssl-dev  \
	libtool  \
	libusb-1.0-0-dev \
	libxml2 \
	libxml2-dev  \
	libxslt1-dev \
	#mscgen  \
	#octave-signal \
	#openssh-client \
	#openssl \
	python  \
	protobuf-c-compiler \
	#subversion \
	xmlstarlet \
	libyaml-dev \
	wget \
	libxpm-dev \
    libboost-all-dev 

#RUN apt-get install xxd

RUN update-alternatives --set "liblapack.so-x86_64-linux-gnu" "/usr/lib/x86_64-linux-gnu/atlas/liblapack.so"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nettle-dev nettle-bin xxd

# dependencies for ethus drivers
#RUN apt-get update && 
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libuhd-dev \
    libuhd3.15.0

COPY scripts/ /scripts
COPY patches/ /patches
	
RUN cd /scripts && ./build_missing_packages

# Get OAI 
RUN git clone --depth=1 --branch=v$VERSION https://gitlab.eurecom.fr/oai/openairinterface5g.git

COPY patches /patches

RUN patch -p1 -d openairinterface5g < patches/disable_building_nasmesh_and_rbtool.patch 

RUN cd /openairinterface5g/cmake_targets && ./build_oai -c --eNB -w USRP --verbose-compile


FROM ubuntu:20.04

ARG version=1.2.2
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
		libatlas3-base \
		libboost-chrono1.71.0 \
		libboost-date-time1.71.0 \
		libboost-filesystem1.71.0 \
		libboost-regex1.71.0 \
		libboost-serialization1.71.0 \
		libboost-thread1.71.0 \
		libconfig9 \
		libidn11 \
		libnettle7 \
		libprotobuf-c1 \
		libssl1.1 \
		libuhd3.15.0 \
		libusb-1.0-0 \
		libyaml-0-2 \
		lksctp-tools \
		zlib1g \
		iproute2 iputils-ping procps bind9-utils net-tools && \
    rm -rf /var/lib/apt/lists/*

ENV APP_ROOT=/opt/oai
COPY --from=builder /openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem ${APP_ROOT}/bin/
COPY configs ${APP_ROOT}/etc/
COPY --from=builder /openairinterface5g/cmake_targets/lte_build_oai/build/*.so* /usr/local/lib/
# update /usr/local/lib libraries 
RUN ldconfig

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

# TODO: run with non-root user
#RUN groupadd -r oai && useradd --no-log-init -r -g oai oai
#RUN chown -R oai:oai ${APP_ROOT}
#USER oai

WORKDIR ${APP_ROOT}

#S1U, GTP/UDP
EXPOSE 2152/udp
# ?  
EXPOSE 22100/tcp 
# S1C, SCTP/UDP
EXPOSE 36412/udp
# X2C, SCTP/UDP 
EXPOSE 36422/udp
# IF5 / ORI (control) 
EXPOSE 50000/udp
# IF5 / ECPRI (data) 
EXPOSE 50001/udp 

CMD ["/opt/oai/bin/lte-softmodem", "-O", "/opt/oai/etc/enb.conf"]