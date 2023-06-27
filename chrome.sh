#!/bin/bash

# Install Google Chrome
sudo apt-get update
sudo apt-get install -y google-chrome-stable

# Install VNC server
sudo apt-get install -y tightvncserver

# Start VNC server and set password
vncserver :1

# Install ngrok
wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok.zip
chmod +x ngrok

# Authenticate ngrok
clear
echo "Go to: https://dashboard.ngrok.com/get-started/your-authtoken"
read -p "Paste Ngrok Authtoken: " CRP
./ngrok authtoken $CRP

clear
echo "Ngrok setup completed!"

# Start ngrok tunnel in the background and redirect output to a log file
echo "Starting ngrok tunnel..."
./ngrok tcp 5901 > ngrok.log &

# Wait for ngrok tunnel to start
sleep 10

# Retrieve ngrok tunnel URL from the log file
NGROK_URL=$(grep -o "tcp://[^[:space:]]*" ngrok.log)

# Output ngrok tunnel information
clear
echo "Ngrok Tunnel Information:"
echo "URL: $NGROK_URL"
echo "Use this URL to connect via NoVNC."

# Connect to the Google Chrome instance using NoVNC
echo "Connecting to Google Chrome instance..."
noVNC/utils/launch.sh --vnc $NGROK_URL

# Cleanup
pkill Xtightvnc
rm -rf ~/.vnc

echo "Script execution completed."
