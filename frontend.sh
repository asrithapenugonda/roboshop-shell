script_location=$(pwd)

echo -e "\e[31m installing nginx \e[0m"
dnf install nginx -y

echo -e "\e[31m enabling nginx \e[0m"
systemctl enable nginx
echo -e "\e[31m starting the nginx \e[0m"
systemctl start nginx

echo -e "\e[31m removing the default content \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[31m downloading our frontend zip file \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[31mnavigating to the desired file \e[0m"
cd /usr/share/nginx/html
echo -e "\e[31m unzipping the frontend content\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[31m creating roboshop configuration \e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[31m restarting the nginx\e[0m"
systemctl restart nginx