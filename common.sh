script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "Refer Log file for more information, LOG - ${LOG}"
    exit 1
  fi
}

print_head() {
  echo -e "\e[40m $1 \e[0m"
}

APP_PREREQ() {

  print_head "Add Application User"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG}
  fi
  status_check

  mkdir -p /app &>>${LOG}

  print_head "Downloading App content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head "Cleanup Old Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}
  status_check

}

SYSTEMD_SETUP() {
  print_head "Configuring ${component} Service File"
  cp ${script_location}/Files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "Enable ${component} Service "
  systemctl enable ${component} &>>${LOG}
  status_check

  print_head "Start ${component} service "
  systemctl start ${component} &>>${LOG}
  status_check
}
LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo"  ]; then
      print_head "Configuring Mongo Repo "
      cp ${script_location}/Files/mongod.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
      status_check

      print_head "Install Mongo Client"
      yum install mongodb-org-shell -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mongo --host mongodb-dev.devopsb70.online </app/schema/${component}.js &>>${LOG}
      status_check
    fi

  fi

}

NODEJS() {

  print_head "Disable the current Nodejs"
  dnf module disable nodejs -y  &>>${LOG}
  status_check

  print_head "Enable the  Nodejs:18"
  dnf module enable nodejs:18 -y &>>${LOG}
  status_check

  print_head "Installing Nodejs"
  dnf install nodejs -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Installing NodeJS Dependencies"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA
}


