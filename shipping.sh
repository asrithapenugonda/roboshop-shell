source common.sh

if [ -z  "${root_mysql_password}" ]; then
  echo " there is not root_mysql_password variable"
  exit

fi

component=shipping
schema_load=True
schema_type=mysql

MAVEN
