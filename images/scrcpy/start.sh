#!/bin/bash

/usr/bin/Xvfb :1 -screen 0 ${VNC_SCREEN} +extension RANDR &
/usr/bin/x11vnc -display :1 ${X11VNC_AUTH} -wait 5 -forever -xrandr &
export DISPLAY=:1
echo "Launching scrcpy, press CTRL-C to exit"
scrcpy --window-width ${SCREEN_WIDTH} --window-x 0 --window-y 0
while [ $? -ne 130 ]
do
  echo "scrcpy exited. Relaunching scrcpy, press CTRL-C to exit"
  sleep 5
  scrcpy --window-width ${SCREEN_WIDTH} --window-x 0 --window-y 0
done

exit 0