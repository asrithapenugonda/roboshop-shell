script_loc=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[33mInstalling nginx\e[0m"
yum install nginx -y &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[33mEnable nginx\e[om"
systemctl enable nginx &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "\e[33mStarting Nginx\e[0m"
systemctl start nginx &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[33mREmoving existing content in nginx\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "\e[33mdownloading the zip file\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "\e[33mmoving to the html directory\e[0m"
cd /usr/share/nginx/html &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "\e[33munxipping the frontend file\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[34mcalling out ngnix configuration/e[0m"
cp ${script_loc}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[34mrestarting nginx/e[0m"
systemctl restart nginx &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi