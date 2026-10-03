source common.sh


print_head "Diabale existing redis"
dnf module disable redis -y &>>${LOG}

status_check

print_head "Enable redis version 6"
dnf module enable redis:6.2 -y &>>${LOG}
status_check

print_head "Installing mongodb"
dnf install redis -y  &>>${LOG}
status_check

print_head "Changing listen address to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG}
status_check

print_head "Enable mongodb"
systemctl enable redis &>>${LOG}
status_check

print_head "restart mongodb"
systemctl restart redis &>>${LOG}
status_check