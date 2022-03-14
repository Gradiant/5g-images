FROM ubuntu:20.04

LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
      org.opencontainers.image.vendor="Gradiant" \
      org.opencontainers.image.licenses="Apache-2.0"

ENV VERSION=1.12.1+ds-1

ENV VNC_SCREEN_SIZE 512x960
ENV VNC_PASSWORD ""

RUN apt-get update && \
    apt-get install -y \
      x11vnc \
      fluxbox \
      xvfb \
      scrcpy=$VERSION && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.fluxbox && \
	  echo ' \n\
		session.screen0.toolbar.visible:        false\n\
		session.screen0.fullMaximization:       true\n\
		session.screen0.maxDisableResize:       true\n\
		session.screen0.maxDisableMove: true\n\
		session.screen0.defaultDeco:    NONE\n\
	' >> /root/.fluxbox/init && \
    mkdir -p /root/.android && adb start-server


EXPOSE 5900

COPY entrypoint.sh start.sh /

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/start.sh"]

