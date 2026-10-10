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
dnf install mysql-server -y &>>${LOG}
status_check

print_head "Enable MySQL"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Start MySQL"
systemctl restart mysqld &>>${LOG}
status_check

print_head "Reset Default Database Password"
#mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}

#sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'; FLUSH PRIVILEGES;"

print_head "Check if MySQL root password is already set"
mysql -u$root_mysql_password -e "SELECT 1;" &>>${LOG}
if [ $? -ne 0 ]; then
  print_head "Setting MySQL Root Password"
  # On fresh install, MySQL 8.0 sometimes uses auth_socket or creates a temporary password.
  # We can alter the root user password directly.
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_mysql_password}'; FLUSH PRIVILEGES;" &>>${LOG}
  status_check
else
  echo "Root password already configured."
  status_check
fi
#status_check