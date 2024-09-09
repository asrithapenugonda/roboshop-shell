source common.sh

if [ -z "${root_mysql_password}" ]
then
  echo "root_mysql_password is missing"
else
  exit 1
fi

print_head " Disable the existing Mysql"
dnf module disable mysql -y  &>>${LOG}
status_check

print_head " Copying the repo file"
cp ${script_location}/Files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check


print_head "Installing mysql"
dnf install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable Mysql"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Start Mysql"
systemctl start mysqld  &>>{LOG}
status_check

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
if [ $? -eq 1 ]; then
  echo "Password is already changed"
fi
status_check
