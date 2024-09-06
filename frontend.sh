script_location=$(pwd)
Log=/tmp/roboshop.log

status_check () {
  if [ $? -eq 0 ]
  then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo "\e[31mFailure\e[0m"
    echo "Refer to the file ${LOG}"
    exit
  fi
}

echo -e "\e[45m installing nginx \e[0m"
dnf install nginx -y &>>${Log}
status_check

echo -e "\e[45m enabling nginx \e[0m"
systemctl enable nginx &>>${Log}
status_check

echo -e "\e[45m starting the nginx \e[0m"
systemctl start nginx &>>${Log}
status_check

echo -e "\e[45m removing the default content \e[0m"
rm -rf /usr/share/nginx/html/* &>>${Log}
status_check

echo -e "\e[45m downloading our frontend zip file \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${Log}
status_check

echo -e "\e[45m navigating to the desired file \e[0m"
cd /usr/share/nginx/html &>>${Log}
status_check

echo -e "\e[45m unzipping the frontend content\e[0m"
unzip /tmp/frontend.zip &>>${Log}
status_check

echo -e "\e[45m creating roboshop configuration \e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${Log}
status_check

echo -e "\e[35m restarting the nginx\e[0m"
systemctl restart nginx &>>${Log}
status_check