source common.sh

install_requirements

print_head "Diabale existing NodeJs"
dnf module disable nodejs -y &>>$(LOG)
status_check

print_head "Enable nojs version 18"
dnf module enable nodejs:18 -y &>>$(LOG)
status_check

print_head "Installing Zip"
dnf install unzip -y &>>$(LOG)
status_check

print_head "Installing nodejs"
dnf install nodejs -y &>>$(LOG)
status_check

print_head "creating user roboshop"
useradd roboshop &>>$(LOG)
status_check


print_head "new directory called /app"
mkdir -p /app &>>$(LOG)
status_check

print_head "Downloading catalogue zip file"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>$(LOG)
status_check

print_head "Deleteing /app contnet if laredaing exists"
rm -rf /app/* &>>$(LOG)
status_check

print_head "changing directory to /app"
cd /app &>>$(LOG)
status_check

print_head "Extracting catalogue zip file"
unzip /tmp/catalogue.zip &>>$(LOG)
status_check

print_head "cd to /app"
cd /app &>>$(LOG)
status_check

print_head "npm install"
npm install &>>$(LOG)
status_check

print_head "Copying catalogue systemd file"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>$(LOG)
status_check

print_head "daemon reload"
systemctl daemon-reload &>>$(LOG)
status_check

print_head "Enable Catalogue"
systemctl enable catalogue &>>$(LOG)
status_check

print_head "start catalogue"
systemctl start catalogue  &>>$(LOG)
status_check

print_head "Copying Mongosb repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>$(LOG)
status_check

print_head "Installing mongodb"
dnf install mongodb-org -y  &>>$(LOG)
status_check

print_head "Changing listen address to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$(LOG)
status_check

print_head "Downloading schema"
mongosh --host mongodb-dev.robospace.online </app/schema/catalogue.js  &>>$(LOG)
status_check