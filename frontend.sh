script_loc=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[33mInstalling nginx\e[0m"
yum install nginx -y &>>${LOG}
echo -e "\e[34mEnable nginx\e[om"
systemctl enable nginx &>>${LOG}
systemctl start nginx &>>${LOG}

rm -rf /usr/share/nginx/html/* &>>${LOG}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}

cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}

cp ${script_loc}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}

systemctl restart nginx &>>${LOG}