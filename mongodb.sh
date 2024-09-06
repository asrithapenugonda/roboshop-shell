source common.sh

print_head " Downloading mongodb Repo"
cp ${script_location}/Files/mongod.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head " Installing Mongodb"
dnf install mongodb-org -y &>>${LOG}
status_check

print_head " Enabling mongodb"
systemctl enable mongod &>>${LOG}
status_check

print_head " Starting the Mongodb"
systemctl start mongod &>>${LOG}
status_check

print_head " Substituing listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head "Restarting the mongodb"
systemctl restart mongod &>>${LOG}
status_check


