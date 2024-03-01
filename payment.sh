source common.sh

if [ -z "${root_rabbitmq_password}" ]; then
  echo "variable root_rabbitmq_password is missing"
  exit 1
fi

component=payment
schema_load=False

PYTHON