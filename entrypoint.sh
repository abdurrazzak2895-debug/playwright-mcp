#!/bin/sh
set -e

# Persistent virtual display that Playwright's headed browser will render into
Xvfb :99 -screen 0 1280x1024x24 &
sleep 2

# Expose that display over VNC (no password — Railway domain is the access control)
x11vnc -display :99 -forever -shared -nopw -rfbport 5900 -bg -o /var/log/x11vnc.log

# Bridge VNC to a browser-accessible noVNC web client on port 6080
websockify --web=/usr/share/novnc 6080 localhost:5900 &

echo "noVNC viewer available on port 6080"

export DISPLAY=:99

# Foreground process — keeps the container alive
exec npm run start
