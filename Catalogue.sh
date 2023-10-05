script_location=$(pwd)

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

nvm install --lts

nvm alias default $(nvm current)



dnf install nodejs -y
useradd roboshop
mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install

cp ${script_location}/Files/Catalogue.service /etc/systemd/system/Catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue