script_location=$(pwd)

echo -e "/e[32m installing nginx \e[0m"
dnf install nginx -y

echo -e "/[32m enabling nginx \e[0m"
systemctl enable nginx
systemctl start nginx

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
unzip /tmp/frontend.zip

cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx