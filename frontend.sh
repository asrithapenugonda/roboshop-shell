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


echo -e "/e[45mStart Nginx"\e[om]
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


echo -e "/e[33m moving to the directory of html file/e[0m"
cd /usr/share/nginx/html &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[33m Unzipping file/e[0m"
unzip /tmp/frontend.zip &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[33mnginx configuration/e[om"
cp ${script_loc}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "/e[33mrestarting nginx/e[om"
systemctl restart nginx &>>${LOG}
if [ $? = 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi