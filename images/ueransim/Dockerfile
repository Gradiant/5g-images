FROM ubuntu:22.04 AS builder

ARG version=3.1.0
ARG commit=
ENV VERSION=$version
ENV COMMIT=$commit

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \  
      git \
      ca-certificates \
      build-essential \
      cmake \
      make \
      g++ \
      libsctp-dev  \ 
      lksctp-tools && \
      apt-get clean
  

RUN cd /tmp && git clone https://github.com/aligungr/UERANSIM.git && \
    cd UERANSIM && \
    if [ "$VERSION" = "dev" ]; then \
      git checkout $COMMIT; \
    else \
      git checkout v$VERSION; \
    fi
    
RUN cd /tmp/UERANSIM && echo "cmake --version" && make

FROM ubuntu:22.04 AS release 

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \  
      bash \
      bind9-dnsutils \
      curl \
      gettext \
      iperf3 \
      iproute2 \
      iputils-ping \
      libsctp1 \ 
      lksctp-tools \
      libstdc++6 \
      traceroute && \
    apt-get clean

COPY --from=builder /tmp/UERANSIM/build/* /usr/local/bin/
COPY etc/ueransim /etc/ueransim
COPY entrypoint.sh /entrypoint.sh
ENV N2_IFACE=eth0
ENV N3_IFACE=eth0
ENV RADIO_IFACE=eth0
ENV AMF_HOSTNAME=amf
ENV GNB_HOSTNAME=localhost

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
