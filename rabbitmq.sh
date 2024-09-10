source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is missing"
  exit 1
fi


print_head "Downloading Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${LOG}
status_check

print_head "Downloading Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>${LOG}
status_check

print_head " Installing RabbitMQ"
dnf install rabbitmq-server -y  &>>${LOG}
status_check

print_head "Enable RabbitMQ"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "Start RabbitMQ"
systemctl start rabbitmq-server  &>>${LOG}
status_check

print_head ' Adding application user'
rabbitmqctl list users | grep roboshop  &>>{LOG}
if [ $? != 0 ] ; then
  rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi
status_check

print_head "Adding Permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"    &>>${LOG}
status_check