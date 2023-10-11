#!/bin/bash

# Update package list
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=18

echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt-get update

sudo apt-get install nodejs -y

# Display Node.js and npm versions
node -v
npm -v

# Install project dependencies
cd /frontend
npm install

echo "installed all dependecies."

# Create a systemd service file for the React app
cat <<EOF | sudo tee /etc/systemd/system/frontend.service
[Unit]
Description=React App

[Service]
ExecStart=npm start
WorkingDirectory=/frontend
Restart=always
User=$(whoami)

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the systemd service
sudo systemctl enable frontend.service
sudo systemctl start frontend.service
