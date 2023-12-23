script_loc=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[45mInstalling nginx\e[0m"
yum install nginx -y &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi

echo -e "\e[45mEnable nginx\e[om"
systemctl enable nginx &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[45mStart Nginx"
systemctl start nginx &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi

echo -e "/e[45m removing content from nginx /e[om"
rm -rf /usr/share/nginx/html/* &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[45m downloading zip file /e[om"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e moving to the directory of html file"
cd /usr/share/nginx/html &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[45m Unzipping file/e[0m"
unzip /tmp/frontend.zip &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[45mnginx configuration/e[om"
cp ${script_loc}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[45mrestarting nginx/e[om"
systemctl restart nginx &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi