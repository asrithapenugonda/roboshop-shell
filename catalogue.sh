# Store the current working directory
script_location=$(pwd)

# Install the required packages
sudo dnf install -y gcc-c++

# Remove the existing Node.js (if any)
sudo dnf remove nodejs -y

sudo yum install -y curl wget git

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
sudo useradd roboshop

# Create the application directory
sudo mkdir -p /app

# Download the application code
sudo curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
 cd /app
sudo unzip /tmp/catalogue.zip

# Change to the application directory
cd /app

# Install npm dependencies
sudo npm install

# Copy the service file
sudo cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service

# Reload systemd and enable/start the service
sudo systemctl daemon-reload
sudo systemctl enable catalogue
sudo systemctl start catalogue

# Copy MongoDB repository configuration
sudo cp "${script_location}/Files/mongodb.repo" /etc/yum.repos.d/mongodb.repo
sudo yum install mongodb-org-shell -y
