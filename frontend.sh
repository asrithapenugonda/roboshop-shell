source common.sh

install_requriments

print_head "Installing NGinx"
sudo dnf install nginx -y &>>${LOG}
status_check

print_head "Enable NGinx"
systemctl enable nginx  &>>${LOG}
status_check

print_head "start nginx"
systemctl start nginx  &>>${LOG}
status_check

print_head "Deleting content in nginx file"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "Downloading frontend zip file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

print_head "changing path to /usr/share/nginx/html"
cd /usr/share/nginx/html &>>${LOG}
status_check

print_head "Extract the frontend file"
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "updating robohsop config file"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head "restarting NGinx"
systemctl restart nginx &>>${LOG}
status_check
#frontend script