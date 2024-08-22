#!/bin/bash

# Define the location of the script
script_location=$(pwd)

# Copy the MongoDB repo file to the yum repos directory
if [ -f "${script_location}/Files/mongod.repo" ]; then
    cp "${script_location}/Files/mongod.repo" /etc/yum.repos.d/mongodb.repo
else
    echo "mongod.repo file not found!"
    exit 1
fi

# Install MongoDB
dnf install mongodb-org -y
if [ $? -ne 0 ]; then
    echo "Failed to install MongoDB. Check the repository and package name."
    exit 1
fi

# Enable and start the MongoDB service
systemctl enable mongod
systemctl start mongod
if [ $? -ne 0 ]; then
    echo "Failed to start the mongod service."
    exit 1
fi

# Modify the mongod.conf to allow external connections
if [ -f /etc/mongod.conf ]; then
    sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
    systemctl restart mongod
else
    echo "mongod.conf file not found!"
    exit 1
fi

echo "MongoDB installation and configuration completed."
