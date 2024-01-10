source common.sh


print_head " Installing nginx"
yum install nginx -y &>>${LOG}
status_check

print_head " Enable nginx"
systemctl enable nginx &>>${LOG}
status_check

print_head " Starting Nginx"
systemctl start nginx &>>${LOG}
status_check

print_head " Removing existing content in nginx"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check


print_head " downloading the zip file\e"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

print_head " moving to the html directory\e"
cd /usr/share/nginx/html &>>${LOG}
status_check


echo -e "\e[35munxipping the frontend file\e"
unzip /tmp/frontend.zip &>>${LOG}
status_check


print_head " calling out ngnix configuration"
cp "${script_location}/Files/nginx-roboshop.conf" /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head " restarting nginx server"
systemctl restart nginx &>>${LOG}
status_check
