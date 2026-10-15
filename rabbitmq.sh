source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbimq_password is missing"
  exit 1
fi
status_check

print_head " downlaoding Erlang packages "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${LOG}
status_check

print_head " Downloading rabbitmq packages"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG}
status_check

print_head " installing rabbitmq "
dnf install rabbitmq-server -y  &>>${LOG}
status_check

print_head " enable rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head " restart rabbitmq"
systemctl start rabbitmq-server  &>>${LOG}
status_check

print_head "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password}  &>>${LOG}
fi
status_check

print_head "Add Tags to Application User"
rabbitmqctl set_user_tags roboshop administrator  &>>${LOG}
status_check

print_head "Add permission to Application User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${LOG}
status_check