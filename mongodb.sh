source common.sh

print_head " Copying the Script LOcation"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>${LOG}
status_check

print_head " Installing Mongodb"
yum install mongodb-org -y &>>${LOG}
status_check

print_head " Changing listen Ip address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head " Enable mongodb"
systemctl enable mongod &>>${LOG}
status_check

print_head " Rrestart mongodb"
systemctl restart mongod &>>${LOG}
status_check