source common.sh

print_head "Disable the present NOdejs"
dnf module disable nodejs -y &>>${LOG}
status_check

print_head "enable the Nodejs:18"
dnf module enable nodejs:18 -y &>>${LOG}
status_check

print_head "Installing NOdejs"
dnf install nodejs -y &>>${LOG}
status_check

print_head "Adding the user roboshop"
id roboshop &>>${LOG}
if [ $? -ne 0 ]
then
  useradd roboshop &>>${LOG}
fi
status_check

print_head "Creating a directory called app"
mkdir /app &>>${LOG}
status_check

print_head "Downlaoding the zip File"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "Changing the directory to the app"
cd /app &>>${LOG}
status_check

print_head "Unzipping the Zip file"
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "Changing to app directory"
cd /app &>>${LOG}
status_check

print_head "Npm install"
npm install &>>${LOG}
status_check

print_head "Setting Systemd of catalogue"
cp ${script_location}/Files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "Downlaoding mongodb repository"
cp ${script_location}/Files/mongod.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Installing Mongodb"
dnf install mongodb-org -y &>>${LOG}
status_check

print_head "Loading schema"
mongo --host mongodb-dev.robomart.tech </app/schema/catalogue.js &>>${LOG}
status_check

print_head "Restarting the catalogue"
systemctl restart catalogue &>>${LOG}
status_check