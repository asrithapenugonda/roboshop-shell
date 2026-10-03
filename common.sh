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

install_requirements() {

  echo -e "\e[33mInstalling zip\e[0m"
  sudo dnf install zip -y  &>>${LOG}
  status_check

}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}


app_prereq() {
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
    unzip /tmp/${component}.zip &>>${LOG}
    status_check
}

systemd() {
  print_head "Copy ${component} systemd service"
    cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
    status_check

    print_head "Daemon reload and start ${component}service"
    systemctl daemon-reload &>>${LOG}
    systemctl enable ${component} &>>${LOG}
    systemctl start ${component} &>>${LOG}
    status_check
}

LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo"  ]; then
      print_head "Configuring Mongo Repo "
      cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
      status_check

      print_head "Install Mongo Client"
      yum install mongodb-org-shell -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mongo --host mongodb-dev.robospace.online </app/schema/${component}.js &>>${LOG}
      status_check
    fi

    if [ ${schema_type} == "mysql"  ]; then

      print_head "Install MySQL Client"
      yum install mysql -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mysql -h mysql-dev.robospace.online -uroot -p${root_mysql_password} < /app/schema/shipping.sql  &>>${LOG}
      status_check
    fi

  fi
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

  app_prereq

  print_head "Install Node.js dependencies"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check

  systemd

  LOAD_SCHEMA
}

maven() {
    print_head "Install Maven"
    yum install maven -y &>>${LOG}
    status_check

    app_prereq

    print_head "Build a package"
    mvn clean package  &>>${LOG}
    status_check

    print_head "Copy App file to App Location"
    mv target/${component}-1.0.jar ${component}.jar
    status_check

    systemd

    LOAD_SCHEMA

}