FROM golang:1.17.8 as builder

ARG version=1.0.1
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

WORKDIR /root/

RUN apt-get update && apt remove cmdtest && \
    apt-get remove yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn python
   
RUN wget https://github.com/free5gc/webconsole/archive/refs/tags/v$VERSION.tar.gz -O - | tar -xz -C /tmp
RUN mv /tmp/webconsole-$version /tmp/webconsole
RUN cd /tmp/webconsole/frontend && \
    yarn install && \
    yarn build && \
    rm -rf ../public && \
    cp -R build ../public

RUN cd /tmp/webconsole && \
    go build

FROM debian:stable-slim

ARG version=1.0.1
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

WORKDIR /opt/webconsole

COPY --from=builder /tmp/webconsole/public /opt/webconsole/public
COPY --from=builder /tmp/webconsole/webconsole /opt/webconsole/webconsole
COPY config/webuicfg.yaml /etc/free5gc/webuicfg.yaml

ENTRYPOINT [ "/opt/webconsole/webconsole" ]
CMD ["-webuicfg","/etc/free5gc/webuicfg.yaml"]
