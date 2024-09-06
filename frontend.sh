source common.sh

print_head  "Installing Nginx"
dnf install nginx -y &>>${LOG}
status_check

print_head "Enabling Nginx"
systemctl enable nginx &>>${LOG}
status_check

print_head "Starting the Nginx"
systemctl start nginx &>>${LOG}
status_check

print_head "Removing the default nginx content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "Downloading our frontend zip file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

print_head "Navigating to the desired file"
cd /usr/share/nginx/html &>>${LOG}
status_check

print_head "Unzipping the frontend content"
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "Creating roboshop configuration"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head "Restarting the nginx"
systemctl restart nginx &>>${LOG}
status_check