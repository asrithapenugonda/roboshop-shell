source common.sh

print_head "Setting Up Redis Repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>{LOG}
status_check

print_head "Enabling Redis 6.2 version"
dnf module enable redis:remi-6.2 -y &>>{LOG}
status_check

print_head "Installing Redis"
dnf install redis -y  &>>{LOG}
status_check

print_head "Changing the Listen address"
sudo sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf /etc/redis/redis.conf

status_check

print_head "Enable Redis"
systemctl enable redis &>>{LOG}
status_check

print_head "Start Redis"
systemctl start redis &>>{LOG}
status_check
