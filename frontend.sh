script_location=$(pwd)

echo -e "\e[33mInstalling NGinx\e[0m"
sudo dnf install nginx -y
echo -e "\e[33mInstalling zip\e[0m"
sudo dnf install zip -y
echo -e "\e[33mEnable NGinx\e[0m"
systemctl enable nginx
echo -e "\e[33mStart NGinx\e[0m"
systemctl start nginx

echo -e "\e[33mDeleting content in nginx file\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[33mDownloading frontend zip file\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[33mchanging path to /usr/share/nginx/html\e[0m"
cd /usr/share/nginx/html
echo -e "\e[33mExtract the frontend file\e[0m"
unzip /tmp/frontend.zip
echo -e "\e[33m updating robohsop config file\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[33mrestarting NGinx\e[0m"
systemctl restart nginx
#frontend script