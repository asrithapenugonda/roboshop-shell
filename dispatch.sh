source common.sh



install_requirements

schema_load=false

component=dispatch

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is missing"
  exit 1
fi


golang