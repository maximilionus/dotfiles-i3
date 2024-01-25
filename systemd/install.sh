#!/bin/bash

# Script will install all systemd services and enable them for the current user

set -e

SERVICES_DIR=services

echo "Script will ask for the user password, to install and enable"
echo "the systemd services"

# Install services
sudo cp -v $SERVICES_DIR/* /etc/systemd/system/

# Enable services
sudo systemctl enable picom-resume@$USER.service
sudo systemctl enable picom-suspend@$USER.service
