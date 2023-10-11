#!/bin/bash

sudo apt-get update

sudo apt-get install -y python3 python3-pip libpq-dev

if [ ! -d "/backend" ]; then
    git clone -b be-dev https://github.com/namratha-h/devops.git /backend
    pip install -r /backend/requirements.txt

else
    temp_requirements_file="/tmp/requirements.txt"
    cp /backend/requirements.txt "$temp_requirements_file"
    
    git pull origin be-dev
    
    local_requirements_file="/backend/requirements.txt"
    
    if diff -q "$local_requirements_file" "$temp_requirements_file" > /dev/null; then
        echo "No differences in requirements.txt. Skipping npm install."
    else
        echo "Differences found in requirements.txt. Running npm install."
        pip install -r /backend/requirements.txt
    fi
    
    sudo rm -f "$temp_requirements_file"   
fi

python3 /backend/manage.py migrate

file_path="/etc/systemd/system/backend.service"
content="[Unit]
Description=Django App
After=network.target

[Service]
User=$(whoami)
Restart=always
WorkingDirectory=/backend
ExecStart=python3 /backend/manage.py runserver 0.0.0.0:8000

[Install]
WantedBy=multi-user.target
"

if [ ! -e "$file_path" ]; then
    echo "$content" | sudo tee "$file_path" > /dev/null
    if [ $? -eq 0 ]; then
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
sudo systemctl enable backend.service
sudo systemctl start backend.service

# Check service status
sudo systemctl status backend.service
