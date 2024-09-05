script_location=$(pwd)
Log=/tmp/roboshop.log

echo -e "\e[32m installing nginx \e[0m"
dnf install nginx -y &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m enabling nginx \e[0m"
systemctl enable nginx &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m starting the nginx \e[0m"
systemctl start nginx &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m removing the default content \e[0m"
rm -rf /usr/share/nginx/html/* &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m downloading our frontend zip file \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m navigating to the desired file \e[0m"
cd /usr/share/nginx/html &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m unzipping the frontend content\e[0m"
unzip /tmp/frontend.zip &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m creating roboshop configuration \e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[32m restarting the nginx\e[0m"
systemctl restart nginx &>>${Log}
if [ $? -eq 0 ]
then
  echo "Success"
else
  echo "Failure"
fi