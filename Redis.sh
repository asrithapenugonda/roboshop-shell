source common.sh

print_head " set up redis repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>${LOG}
status_check

print_head " Enabling redis 6.0"
dnf module enable redis:remi-6.2 -y &>>${LOG}
status_check

print_head " Installing redis"
dnf install redis -y  &>>${LOG}
status_check


print_head " Changing listen Ip address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /vim /etc/redis.conf vim /etc/redis/redis.conf &>>${LOG}
status_check

print_head " Enable redis"
systemctl enable redis &>>${LOG}
status_check

print_head " Restart redis"
systemctl start redis &>>${LOG}
status_check