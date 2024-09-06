script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check (){
  if [ $? -eq 0 ]
  then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
    echo -e "Refer Log failure "
}

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


cp ${script_location}/Files/mongod.repo /etc/yum.repos.d/mongodb.repo

dnf install mongodb-org -y
mongo --host mongodb-dev.robomart.tech </app/schema/catalogue.js

systemctl restart catalogue