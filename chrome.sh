#!/bin/bash

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

# Start ngrok tunnel
echo "Choose ngrok region (for better connection):"
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "Enter ngrok region: " REGION

./ngrok tcp --region $REGION 4000 &

# Wait for ngrok tunnel to start
echo "Starting ngrok tunnel..."
sleep 10

# Retrieve ngrok tunnel URL
NGROK_URL=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p')

# Output ngrok tunnel information
clear
echo "Ngrok Tunnel Information:"
echo "URL: $NGROK_URL"
echo "Use this URL to connect to your VM via ngrok."

# Chrome virtual machine installation
docker run --rm -d --network host --privileged --name chrome-browser -e PASSWORD=123456 -e USER=user --cap-add=SYS_PTRACE --shm-size=1g alpine /bin/sh -c "apk add --no-cache chromium && /usr/bin/chromium-browser --no-sandbox"

clear
echo "Google Chrome Installed Successfully!"
echo "Access your Chrome virtual machine via NoMachine."
echo "NoMachine: https://www.nomachine.com/download"
echo "======================="
echo "NoMachine Information:"
echo "IP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "User: user"
echo "Password: 123456"
echo "If the VM can't connect, restart Cloud Shell and then re-run the script."

# Keep the script running to maintain the ngrok tunnel
while true; do sleep 10; done
