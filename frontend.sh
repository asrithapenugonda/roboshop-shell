script_location=$(pwd)
Log=/tmp/roboshop.log

echo -e "\e[31m installing nginx \e[0m"
dnf install nginx -y &>>${Log}

echo -e "\e[31m enabling nginx \e[0m"
systemctl enable nginx &>>${Log}
echo -e "\e[31m starting the nginx \e[0m"
systemctl start nginx &>>${Log}

echo -e "\e[31m removing the default content \e[0m"
rm -rf /usr/share/nginx/html/* &>>${Log}

echo -e "\e[31m downloading our frontend zip file \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${Log}
echo -e "\e[31mnavigating to the desired file \e[0m"
cd /usr/share/nginx/html &>>${Log}
echo -e "\e[31m unzipping the frontend content\e[0m"
unzip /tmp/frontend.zip &>>${Log}

echo -e "\e[31m creating roboshop configuration \e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${Log}

echo -e "\e[31m restarting the nginx\e[0m"
systemctl restart nginx &>>${Log}