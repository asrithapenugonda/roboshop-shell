script_location=$(pwd)

dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install unzip -y

dnf install nodejs -y

useradd roboshop

mkdir-p /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
rm -rf /app/*
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install

cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue
systemctl start catalogue

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
dnf install mongodb-org -y

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf