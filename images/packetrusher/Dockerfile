FROM ubuntu:focal AS builder

RUN apt-get update && apt install wget git make -y

RUN wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

RUN git clone https://github.com/HewlettPackard/PacketRusher.git

RUN cd PacketRusher \
    && go mod download \
    && go build cmd/packetrusher.go

FROM ubuntu:focal AS packetrusher

RUN apt update && apt install vim iproute2 iputils-ping iperf3 net-tools traceroute gettext-base dnsutils -y

COPY --from=builder /usr/local/go /usr/local
ENV PATH=$PATH:/usr/local/go/bin

WORKDIR /PacketRusher
COPY --from=builder /PacketRusher/packetrusher .
COPY config/config.yml config/
COPY entrypoint.sh .

ENV GNB_NGAP_DEV=eth0 \
    GNB_GTPU_DEV=eth0 \
    AMF_HOSTNAME=amf \
    MCC=999 \
    MNC=70 \
    TAC=000001 \
    GNBID=000008 \
    GNBSST=01 \
    GNBSD=000001 \
    MSIN=0000000001 \
    KEY=491BB1C6E1179AED538028AE7AD525B3 \
    OPC=3B7FB099B3A6D16873B33F023B1679E9 \
    DNN=internet \
    UESST=01 \
    UESD=000001

ENTRYPOINT ["/PacketRusher/entrypoint.sh"]