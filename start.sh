#!/bin/bash

# Start virtual display
Xvfb :1 -screen 0 1024x768x16 & export DISPLAY=:1

# Start XFCE desktop session
dbus-launch xfce4-session &

# Set up VNC password (optional, can be skipped if using no auth for simplicity)
mkdir -p ~/.vnc
echo "password" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start VNC server
x11vnc -storepasswd password ~/.vnc/passwd
x11vnc -forever -usepw -display :1 -rfbport 5901 &

# Start noVNC with websockify on port 7860
cd ~/novnc
./utils/launch.sh --vnc localhost:5901 --listen 7860
