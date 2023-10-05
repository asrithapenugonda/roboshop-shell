script_location=$(pwd)

sudo yum install epel-release

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