from debian:testing-slim


ENV VNC_PASSWORD=changeme \
    VNC_PORT=5900 

RUN apt-get update && \
    apt-get install -y \
      ca-certificates \
      tigervnc-standalone-server \
      fluxbox \
      libgbm1 \
      libasound2 \
      scrcpy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#RUN echo 'deb [arch=amd64, trusted=yes] https://nuts.vysor.io/apt ./' > /etc/apt/sources.list.d/vysor.list && \
#    apt-get update && \    
#    apt-get install -y \
#     vysor && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
    
COPY start.sh /
RUN mkdir -p /root/.android
# We start adb server to create a fixed adbkey
RUN adb start-server

CMD ["/start.sh"]


