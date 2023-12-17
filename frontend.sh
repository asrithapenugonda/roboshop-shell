script_loc=$(pwd)
LOG=/tmp/roboshop.log

yum install nginx -y &>>${LOG}
systemctl enable nginx &>>${LOG}
systemctl start nginx &>>${LOG}

rm -rf /usr/share/nginx/html/* &>>${LOG}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}

cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}

cp ${script_loc}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}

systemctl restart nginx &>>${LOG}