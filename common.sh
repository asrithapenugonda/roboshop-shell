script_location=$(pwd)
LOG=/tmp/roboshop.log

#status-check function
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
    echo -e "Refer log file for furthur information, LOG - ${LOG}"
    exit
  fi
}

print_head() {
  echo -e "\e[35m $1 \e[0m"
}

APP_PREQS(){
  print_head " Create an user for your application"
    id roboshop &>>${LOG}
    if [ $? -ne 0 ] ; then
    useradd roboshop &>>${LOG}
    fi
    status_check

    print_head " Create the application directory"
    mkdir -p /app &>>${LOG}
    status_check

    print_head " Download the application code"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
    status_check

    print_head " Changing directory to application"
    cd /app &>>${LOG}
    status_check

    print_head " removing content in application"
    rm -rf /app/* &>>${LOG}
    status_check

    print_head " unzipping the file"
    unzip /tmp/${component}.zip &>>${LOG}
    status_check

}

SERVICE_SETUP() {

    print_head "Copy the service file"
    cp ${script_location}/Files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
    status_check

    print_head " daemon reload"
    systemctl daemon-reload &>>${LOG}
    status_check

    print_head " enable ${component}"
    systemctl enable ${component} &>>${LOG}
    status_check

    print_head " start ${component} "
    systemctl start ${component} &>>${LOG}
    status_check

}

LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo"  ]; then
      print_head "Configuring Mongo Repo "
      cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
      status_check

      print_head "Install Mongo Client"
      yum install mongodb-org-shell -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mongo --host mongodb-dev.robomart.tech </app/schema/${component}.js &>>${LOG}
      status_check
    fi

    if [ ${schema_type} == "mysql"  ]; then

      print_head "Install MySQL Client"
      yum install mysql -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mysql -h mysql-dev.robomart.tech -uroot -p${root_mysql_password} < /app/schema/shipping.sql  &>>${LOG}
      status_check
    fi

  fi
}


NODEJS() {
  source common.sh

  print_head "Disable node js if already exists"
  dnf module disable nodejs -y &>>${LOG}
  status_check

  print_head "Enable node js"
  dnf module enable nodejs:18 -y &>>${LOG}
  status_check


  print_head "installing Nodejs"
  dnf install nodejs -y &>>${LOG}
  status_check

  APP_PREQS

  print_head " Change to the application directory"
  cd /app &>>${LOG}
  status_check

  print_head " Install npm dependencies"
  npm install &>>${LOG}
  status_check

  SERVICE_SETUP
  LOAD_SCHEMA
}

MAVEN() {
  print_head " INstalling Maven"
  dnf install maven -y &>>${LOG}
  status_check

  APP_PREQS

  print_head " changing to app directory"
  cd /app  &>>${LOG}
  status_check

  print_head "Cleaning up package"
  mvn clean package &>>${LOG}
  status_check

  print_head " Downloading packaages for building application"
  mv target/{component}-1.0.jar {component}.jar  &>>${LOG}
  status_check

  SERVICE_SETUP
  LOAD_SCHEMA


}


