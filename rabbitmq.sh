source common.sh

if [ -z "${root_rabbitmq_password}" ]; then
  echo "variable root_rabbitmq_password is missing"
  exit 1
fi

print_head "Configuring erlang yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${LOG}
status_check

print_head "Configuring rabitMq yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG}
status_check

print_head "Installing erlang and rabbitmq"
dnf install erlang rabbitmq-server -y &>>${LOG}
status_check

print_head "enabling rabbitmq"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "starting rabbitmq server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "adding user "
rabbitmqctl add_user roboshop ${root_rabbitmq_password} &>>${LOG}
status_check

print_head "setting up permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check