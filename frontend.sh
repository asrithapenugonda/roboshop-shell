script_location=$(pwd)

echo -e "/e[32m installing nginx [0m \e"
dnf install nginx -y

systemctl enable nginx
systemctl start nginx

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
unzip /tmp/frontend.zip

cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx