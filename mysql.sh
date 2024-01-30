source common.sh

if [ -z  "${root_mysql_password}" ] ; then
  echo " no variable root-mysql-password"
  exit
fi
print_head "Disable mysql if present"
dnf module disable mysql -y &>>${LOG}
status_check

print_head " Copying the repo file"
cp ${script_location}/Files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head " Installing mysql"
dnf install mysql-community-server -y  &>>${LOG}
status_check

print_head "enable  mysql"
systemctl enable mysqld  &>>${LOG}
status_check

print_head " Start Mysql"
systemctl start mysqld &>>${LOG}
status_check

print_head "Reset default password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>{LOG}
status_check
