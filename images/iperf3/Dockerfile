FROM alpine:latest

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0"

RUN apk add --no-cache iperf3

ENTRYPOINT ["iperf3"]

