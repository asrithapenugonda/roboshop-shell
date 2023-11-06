#!/bin/bash

# Store the current working directory
script_location=$(pwd)

# Install the required packages
sudo dnf install -y gcc-c++

# Remove the existing Node.js (if any)
sudo dnf remove nodejs -y

sudo yum install -y curl wget git
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node



# Check Node.js and npm versions
node -v
npm -v

# Create a user for your application
sudo useradd roboshop

# Create the application directory
sudo mkdir -p /app

# Download the application code
app_code_url="https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip"

sudo curl -L -o /tmp/catalogue.zip "$app_code_url"
sudo rm -rf /app/*
cd /app
sudo unzip /tmp/catalogue.zip -d /app
cd /app
npm install

# Copy the service file
sudo cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service

# Reload systemd and enable/start the service
sudo systemctl daemon-reload
sudo systemctl enable catalogue
sudo systemctl start catalogue
sudo systemctl restart catalogue