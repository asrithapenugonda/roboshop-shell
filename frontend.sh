script_loc=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
  fi
}

echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y &>>${LOG}
status_check

echo -e "\e[35mEnable nginx\e[0m"
systemctl enable nginx &>>${LOG}
status_check

echo -e "\e[35mStarting Nginx\e[0m"
systemctl start nginx &>>${LOG}
status_check
echo -e "\e[35mREmoving existing content in nginx\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check


echo -e "\e[35mdownloading the zip file\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

echo -e "\e[35mmoving to the html directory\e[0m"
cd /usr/share/nginx/html &>>${LOG}
status_check


echo -e "\e[35munxipping the frontend file\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
status_check


echo -e "\e[35mcalling out ngnix configuration\e[0m"
cp ${script_loc}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

echo -e "\e[35mrestarting nginx server[0m\e"
systemctl restart nginx &>>${LOG}
status_check
