#!/bin/bash

# Store the current working directory
script_location=$(pwd)

sudo dnf install -y gcc-c++

# Remove the existing Node.js (if any)
sudo dnf remove nodejs -y

# Install Node.js using NodeSource for version 18.x
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo -E bash -


# Create a user for your application
sudo useradd roboshop

# Create the application directory
sudo mkdir -p /app

# Download the application code
app_code_url="https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip"
sudo rm -rf /app/*
sudo curl -L -o /tmp/catalogue.zip "$app_code_url"
sudo unzip /tmp/catalogue.zip -d /app
cd /app
npm install

# Copy the service file
sudo cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service

# Reload systemd and enable/start the service
sudo systemctl daemon-reload
sudo systemctl enable catalogue
sudo systemctl start catalogue
