#!/bin/bash

# Store the current working directory
script_location=$(pwd)

# Install the required packages
sudo dnf install -y gcc-c++

# Remove the existing Node.js (if any)
sudo dnf remove nodejs -y

# Download and extract Node.js
node_version="v14.18.1"
node_url="https://nodejs.org/dist/$node_version/node-$node_version-linux-x64.tar.xz"
wget "$node_url"
tar -xf "node-$node_version-linux-x64.tar.xz"
sudo cp -r "node-$node_version-linux-x64/"* /usr/local/
rm -rf "node-$node_version-linux-x64.tar.xz" "node-$node_version-linux-x64"

# Check Node.js and npm versions
node -v
npm -v

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
