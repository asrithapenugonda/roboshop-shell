# Store the current working directory
script_location=$(pwd)
set -e

# Install the required packages
dnf install -y gcc-c++

# Remove the existing Node.js (if any)
dnf remove nodejs -y
 yum install -y curl wget git

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Source NVM directly to make it available in the current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js
nvm install node

# Check Node.js and npm versions
node -v
npm -v

# Create a user for your application
 #useradd roboshop

# Create the application directory
mkdir -p /app

# Download the application code
 curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
 cd /app
  rm -rf /app/*
unzip /tmp/catalogue.zip

# Change to the application directory
cd /app

# Install npm dependencies
 npm install

# Copy the service file
 cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service

# Reload systemd and enable/start the service
 systemctl daemon-reload
systemctl enable catalogue
 systemctl start catalogue

# Copy MongoDB repository configuration
 cp "${script_location}/Files/mongodb.repo" /etc/yum.repos.d/mongodb.repo
 yum install mongodb-org-shell -y
