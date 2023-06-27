#!/bin/bash

clear
echo "Installing Chrome and setting up NoVNC..."

# Install dependencies
sudo apt-get update
sudo apt-get install -y wget xvfb x11vnc novnc

# Download and install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -y -f
rm google-chrome-stable_current_amd64.deb

# Start virtual display
Xvfb :1 -screen 0 1024x768x16 &
export DISPLAY=:1

# Start Chrome
google-chrome-stable --no-sandbox &

# Start NoVNC server
x11vnc -display :1 -nopw -listen localhost -xkb -bg -ncache 10 -forever &

# Start NoVNC web interface
nohup novnc --listen 8080 >/dev/null 2>&1 &

# Get public IP address
IP_ADDRESS=$(curl -s ifconfig.me)

clear
echo "Chrome installation and NoVNC setup completed!"
echo "You can now connect to the Chrome instance using the following URL:"
echo "http://$IP_ADDRESS:8080/vnc.html"

echo "Script execution completed."
