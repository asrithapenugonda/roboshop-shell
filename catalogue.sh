source common.sh

print_head " Disable node js if already exists"
dnf module disable nodejs -y &>>${LOG}
status_check

print_head " Enable node js"
dnf module enable nodejs:18 -y &>>${LOG}
status_check


print_head " installing Nodejs"
dnf install nodejs -y &>>${LOG}
status_check

print_head " Create an user for your application"
id roboshop &>>${LOG}
if [ $? -ne 0 ] ; then
useradd roboshop &>>${LOG}
fi
status_check

print_head " Create the application directory"
mkdir -p /app &>>${LOG}
status_check

print_head " Download the application code"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head " Changing directory to application"
cd /app &>>${LOG}
status_check

print_head " removing content in application"
rm -rf /app/* &>>${LOG}
status_check

print_head " unzipping the file"
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head " Change to the application directory"
cd /app &>>${LOG}
status_check

print_head " Install npm dependencies"
npm install &>>${LOG}
status_check

print_head" Copy the service file"
cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head " daemon reload"
systemctl daemon-reload &>>${LOG}
status_check

print_head " enable catalogue"
systemctl enable catalogue &>>${LOG}
status_check

print_head " start catalogue "
systemctl start catalogue &>>${LOG}
status_check

print_head" Copy MongoDB repository configuration"
cp "${script_location}/Files/mongodb.repo" /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head " installing mongodb"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head " loading schema"
mongo --host localhost </app/schema/catalogue.js &>>${LOG}
status_check