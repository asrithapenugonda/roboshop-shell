source common.sh


print_head "Copying mongodb repo file "
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Installing mongodb"
dnf install mongodb-org -y &>>$(LOG)
status_check

print_head "Changing listen address to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$(LOG)
status_check

print_head "Enable mongodb"
systemctl enable mongod &>>$(LOG)
status_check

print_head "restart mongodb"
systemctl restart mongod &>>$(LOG)
status_check