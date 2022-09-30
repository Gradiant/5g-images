FROM ubuntu:22.04 as builder

ARG version=2.4
ENV VERSION=$version

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="$version"

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      git \
      libnuma-dev \
      python3 \
      python3-distutils \
      python-is-python3 && \
    apt-get clean

RUN git clone git://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git && \
    cd rt-tests && \
    git checkout v$VERSION && \
    make all && \
    make install

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
      python3 && \
    apt-get clean
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/lib/python3/dist-packages/get_cyclictest_snapshot.py /usr/lib/python3/dist-packages/hwlatdetect.py   /usr/lib/python3/dist-packages/