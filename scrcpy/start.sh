#!/bin/sh

echo "Starting VNC SERVER"


if [ "$VNC_PORT" -lt 5900 ]; then
  echo "ERROR - VNC port must be 5900 or greater!"
  exit 1
fi

export VNC_DISPLAY=:$(($VNC_PORT - 5900))

echo "VNC port: $VNC_PORT"
echo "VNC IP: `hostname -i`"
echo "VNC Display: $VNC_DISPLAY"
if [ ! -e /root/.vnc ]; then
  mkdir /root/.vnc
fi

# Set VNC password
echo "$VNC_PASSWORD" | tigervncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Cleanup previous VNC session data
tigervncserver -kill "$VNC_DISPLAY"

# Set VNC security
tigervncserver -SecurityTypes VncAuth,TLSVnc "$VNC_DISPLAY"
export DISPLAY="$VNC_DISPLAY"

echo "Launching scrcpy, press CTRL-C to exit"
scrcpy
while [ $? -ne 130 ]
do
  echo "scrcpy exited. Relaunching scrcpy, press CTRL-C to exit"
  sleep 5
  scrcpy
done
