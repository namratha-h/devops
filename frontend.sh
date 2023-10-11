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


if [ ! -d "/frontend" ]; then
    # If the directory doesn't exist, clone the project
    git clone -b fe-dev https://github.com/namratha-h/devops.git /frontend
    cd /frontend
    npm install

else
    cd /frontend
    
    # Path to the temporary package.json file
    temp_package_json="/tmp/temp_package.json"
    cp package.json "$temp_package_json"
    
    git pull origin fe-dev
    
    # Path to the local package.json file
    local_package_json="/frontend/package.json"
    
    # Compare the local and tmp package.json files
    if diff -q "$local_package_json" "$temp_package_json" > /dev/null; then
        echo "No differences in package.json. Skipping npm install."
    else
        echo "Differences found in package.json. Running npm install."
        npm install
    fi
    
    # Clean up temporary file
    sudo rm -f "$temp_package_json"   
fi


file_path="/etc/systemd/system/frontend.service"
content="[Unit]
Description=React App

[Service]
ExecStart=npm start
WorkingDirectory=/frontend
Restart=always
User=$(whoami)

[Install]
WantedBy=multi-user.target
"

if [ ! -e "$file_path" ]; then
    echo "$content" | sudo tee "$file_path" > /dev/null
    if [ $? -eq 0 ]; then
        # Reload systemd to apply changes
        sudo systemctl daemon-reload
        echo "File created successfully: $file_path"
    else
        echo "Error: Failed to create the file."
        exit 1
    fi
else
    echo "File already exists. Skipping creation."
fi


# Enable and start the service
sudo systemctl enable frontend.service
sudo systemctl start frontend.service

# Check service status
sudo systemctl status frontend.service
