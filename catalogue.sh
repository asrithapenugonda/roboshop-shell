# Store the current working directory

script_location=$(pwd)
LOG=/tmp/roboshop.log

#status-check function
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
  fi
}
# Install the required packages

echo -e "\e[36m Disable node js if present\e[0"
dnf module disable nodejs -y &>>${LOG}
status_check

echo -e "\e[36m enable nodejs 18 version\e[0"
dnf module enable nodejs:18 -y &>>${LOG}
status_check


echo -e "\e[36m installing Nodejs\e[0"
dnf install nodejs -y &>>${LOG}
status_check

echo -e "\e[36m Create a user for your application\e[0"
useradd roboshop &>>${LOG}
status_check

echo -e "\e[36mCreate the application directory\e[0"
mkdir -p /app &>>${LOG}
status_check

echo -e "\e[36mDownload the application code\e[0"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check
echo -e "\e[36m Changing directory to application\e[0"
cd /app &>>${LOG}
status_check
echo -e "\e[36m removing content in application\e[0"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[36m unzipping the file\e[0"
unzip /tmp/catalogue.zip &>>${LOG}
status_check
echo -e "\e[36m Change to the application directory\e[0"
cd /app &>>${LOG}
status_check
echo -e "\e[36mInstall npm dependencies\e[0"
npm install &>>${LOG}
status_check

echo -e "\e[36mCopy the service file\e[0"
cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service &>>${LOG}
status_check
echo -e "\e[36mReload systemd and enable/start the service\e[0"
echo -e "\e[36m daemon reload\e[0"
systemctl daemon-reload &>>${LOG}
status_check
echo -e "\e[36m enable catalogue\e[0"
systemctl enable catalogue &>>${LOG}
status_check
echo -e "\e[36m start catalogue \e[0"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\e[36mCopy MongoDB repository configuration\e[0"
cp "${script_location}/Files/mongodb.repo" /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check
echo -e "\e[36m installing mongodb\e[0"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[36m loading schema\e[0m"
mongo --host localhost </app/schema/catalogue.js &>>${LOG}
status_check