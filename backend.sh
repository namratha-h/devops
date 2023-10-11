#!/bin/bash

sudo apt-get update

sudo apt-get install -y python3 python3-pip libpq-dev

# Specify the service name and description
SERVICE_NAME="backend"

# Specify the path to your application directory and startup command
APP_DIR="/backend"

if [ -e /backend/requirements.txt ]; then
    pip install -r /backend/requirements.txt
fi

python3 /backend/manage.py migrate

APP_START_CMD="python3 /backend/manage.py runserver 0.0.0.0:8000"

# Create the systemd service unit file
cat <<EOF | sudo tee "/etc/systemd/system/${SERVICE_NAME}.service" > /dev/null
[Unit]
Description="Django Backend Application Service"
After=network.target

[Service]
User=$(whoami)
Restart=always
WorkingDirectory=${APP_DIR}
ExecStart=${APP_START_CMD}

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to read the new service unit file
systemctl daemon-reload

# Enable and start the service
systemctl enable ${SERVICE_NAME}.service
systemctl start ${SERVICE_NAME}.service
