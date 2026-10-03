script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
  then
    echo -e "\e[42mSUCCESS\e[0m"
  else
    echo -e "\e[41mFailure\e[0m"
    echo " Refer log file for information log-$LOG"
    exit
  fi
}

install_requriments() {

  echo -e "\e[33mInstalling zip\e[0m"
  sudo dnf install zip -y  &>>${LOG}
  status_check

}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

nodejs() {
  print_head "Disable existing Node.js module"
  dnf module disable nodejs -y &>>${LOG}
  status_check

  print_head "Enable Node.js 18 module"
  dnf module enable nodejs:18 -y &>>${LOG}
  status_check

  print_head "Install unzip and Node.js"
  dnf install unzip nodejs -y &>>${LOG}
  status_check

  print_head "Create application user roboshop"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG}
  fi
  status_check

  print_head "Create /app directory"
  mkdir -p /app &>>${LOG}
  status_check

  print_head "Download application artifact"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head "Clean existing content and change directory"
  rm -rf /app/* &>>${LOG}
  cd /app &>>${LOG}
  status_check

  print_head "Extract application artifact"
  unzip /tmp/catalogue.zip &>>${LOG}
  status_check

  print_head "Install Node.js dependencies"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check

  print_head "Copy catalogue systemd service"
  cp ${script_location}/files/catalogue.service /etc/systemd/system/{component}.service &>>${LOG}
  status_check

  print_head "Daemon reload and start catalogue service"
  systemctl daemon-reload &>>${LOG}
  systemctl enable catalogue &>>${LOG}
  systemctl start catalogue &>>${LOG}
  status_check

  if [ ${schema_load == true ] ; then

  print_head "Copy MongoDB repository file"
  cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
  status_check

  print_head "Install MongoDB client (mongosh)"
  dnf install mongodb-mongosh -y &>>${LOG}
  status_check

  print_head "Load schema into MongoDB"
  mongosh --host mongodb-dev.robospace.online </app/schema/${component}.js &>>${LOG}
  status_check

  fi

}