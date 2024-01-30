source common.sh

if [ -z  "${root-mysql-password}" ] ; then
  echo " There is no password present"
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

