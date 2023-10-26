#!/bin/bash

# Store the current working directory
script_location=$(pwd)

# Install the required packages
sudo dnf install -y gcc-c++

# Remove the existing Node.js (if any)
sudo dnf remove nodejs -y

# Download and extract Node.js
wget https://nodejs.org/dist/v14.18.1/node-v14.18.1-linux-x64.tar.xz
tar -xf node-v14.18.1-linux-x64.tar.xz
sudo cp -r node-v14.18.1-linux-x64/* /usr/local/
rm -rf node-v14.18.1-linux-x64.tar.xz node-v14.18.1-linux-x64

# Check Node.js and npm versions
node -v
npm -v

# Create a user for your application
sudo useradd roboshop

# Create the application directory
sudo mkdir -p /app

# Download the application code
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
sudo unzip /tmp/catalogue.zip -d /app
rm -f /tmp/catalogue.zip

# Copy the service file
sudo cp ${script_location}/Files/catalogue.service /etc/systemd/system/Catalogue.service

# Reload systemd and enable/start the service
sudo systemctl daemon-reload
sudo systemctl enable catalogue
sudo systemctl start catalogue
