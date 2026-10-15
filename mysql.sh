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
print_head "Configure MySQL Root Password"

# 1. Check if the target password already works
mysql -u root -p"${root_mysql_password}" -e "SELECT 1;" &>>${LOG}
if [ $? -eq 0 ]; then
  echo -e "\e[32mRoot password already configured correctly.\e[0m"
else
  # 2. Check if we can connect passwordless (brand new install)
  mysql -e "SELECT 1;" &>>${LOG}
  if [ $? -eq 0 ]; then
    print_head "Setting initial MySQL Root Password"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_mysql_password}'; FLUSH PRIVILEGES;" &>>${LOG}
    status_check
  else
    # 3. If both fail, the state is corrupted/locked out. Clean and re-initialize.
    echo "ERROR: MySQL root login failed."
    echo "Check the root password manually. MySQL data was not deleted."
    exit 1
  fi
fi
#status_check