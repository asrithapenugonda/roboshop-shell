script_location=$(pwd)


dnf module disable nodejs -y
dnf module enable nodejs:18 -y

dnf install nodejs -y

useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
cp ${script_location}/Files/catalogue.service /etc/systemd/system/catalogue.service


cp ${script_location}/File/mongod.repo /etc/yum.repos.d/mongod.repo

dnf install mongodb-org-shell -y
mongo --host mongodb-dev.robomart.tech </app/schema/catalogue.js