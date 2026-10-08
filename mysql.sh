source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "Variable root_mysql_password is missing"
  exit 1
fi


#print_head "Disable MySQL Default Module"
#dnf module disable mysql -y &>>${LOG}
#status_check

#print_head "Copy MySQL Repo file"
#cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
#status_check

print_head "Install MySQL Server"
dnf install mysql-server -y  &>>${LOG}
status_check

print_head "Enable MySQL"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Start MySQL"
systemctl restart mysqld &>>${LOG}
status_check

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}

#temporary_password=$(grep 'temporary password' /var/log/mysqld.log | tail -1 | awk '{print $NF}')
#mysql -uroot -p"${temporary_password}" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_mysql_password}';" &>>${LOG}
status_check
#if [ $? -eq 1 ]; then
 ## echo "Password is already changed"
#fi
#status_check