# VNC Access to Android Remote Devices

This docker image give you access to an USB Android Device through VNC.

## Usage

This docker image needs access to /dev/bus and privileged.

You need to enable usb debugging in your phone, and accept the host connection.

Connect your android phone to the host USB and run:

```
docker run --privileged -v /dev/bus:/dev/bus -p 5900:5900 5openverso/scrcpy
```

Connect with a VNC client to localhost:5900 to remotely control the device. Default password is changeme, can be configured with -e VNC_PASSWORD flag in `docker run`.