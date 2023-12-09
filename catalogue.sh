# Store the current working directory
set -e
script_location=$(pwd)
# Install the required packages


dnf module disable nodejs -y
dnf module enable nodejs:18 -y


dnf install nodejs -y

# Create a user for your application
 useradd roboshop

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

 mongo --host localhost </app/schema/catalogue.js
