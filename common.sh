script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check () {
  if [ $? -eq 0 ]
  then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "Refer to the file ${LOG}"
    exit
  fi
}

print_head () {
  echo -e "\e[40m $1 \e[0m"
}
APP_PREREQ () {

  if [ ! -d "/app" ]; then
    print_head "Creating /app directory"
    mkdir /app &>>${LOG}
    status_check
  fi

  print_head "Downlaoding the zip File"
  curl -o /tmp/$(component).zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head "Changing the directory to the app"
  cd /app &>>${LOG}
  status_check

  print_head "Unzipping the Zip file"
  unzip -o /tmp/${component}.zip &>>${LOG}
  status_check

}

LOAD_SCHEMA () {

  if [ ${schema_load} == "TRUE"]; then

    if [ ${schema_type} == "mongo"  ]; then
            print_head "Configuring Mongo Repo "
            cp ${script_location}/Files/mongod.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
            status_check

            print_head "Install Mongo Client"
            yum install mongodb-org-shell -y &>>${LOG}
            status_check

            print_head "Load Schema"
            mongo --host mongodb-dev.robomart.tech </app/schema/${component}.js &>>${LOG}
            status_check
          fi
  fi
}


SYSTEMD_SETUP () {

  print_head "Setting Systemd of ${component}"
  cp ${script_location}/Files/${component}.service /etc/systemd/system/{$component}.service &>>${LOG}
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

NODEJS () {
  print_head "Disable the present NOdejs"
  dnf module disable nodejs -y &>>${LOG}
  status_check

  print_head "enable the Nodejs:18"
  dnf module enable nodejs:18 -y &>>${LOG}
  status_check

  print_head "Installing NOdejs"
  dnf install nodejs -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Changing to app directory"
  cd /app &>>${LOG}
  status_check

  print_head "Npm install"
  npm install &>>${LOG}
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA

}
