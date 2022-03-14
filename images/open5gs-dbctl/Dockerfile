FROM mongo:latest

ARG version
ENV VERSION=$version

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y wget && \
    apt-get clean
RUN wget -O /usr/local/bin/open5gs-dbctl https://github.com/open5gs/open5gs/raw/main/misc/db/open5gs-dbctl && \
    chmod +x /usr/local/bin/open5gs-dbctl

ENTRYPOINT ["bin/bash", "-c"]

CMD ["/usr/local/bin/open5gs-dbctl"]
