# Store the current working directory

script_location=$(pwd)
LOG=/tmp/roboshop.log

# Install the required packages

echo -e "\e[42m Disable node js if present\e[0"
dnf module disable nodejs -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo " success"
else
  echo "Failure"
fi

echo -e "\e[31m enable nodejs 18 version\e[0"
dnf module enable nodejs:18 -y &>>${LOG}
if [ $? -eq 0 ] ; then
  echo "Success"
else
  echo "Failure"
fi


echo -e "\e[31m installing Nodejs\e[0"
dnf install nodejs -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[31m Create a user for your application\e[0"
useradd roboshop &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[31mCreate the application directory\e[0"
mkdir -p /app &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[31mDownload the application code\e[0"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[34m Changing directory to application\e[0"
cd /app &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[34m removing content in application\e[0"
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[34m unzipping the file\e[0"
unzip /tmp/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi



echo -e "\e[34m Change to the application directory\e[0"
cd /app &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[34mInstall npm dependencies\e[0"
npm install &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[34mCopy the service file\e[0"
cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[34mReload systemd and enable/start the service\e[0"
echo -e "\e[32m daemon reload\e[0"
systemctl daemon-reload &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[34m enable catalogue\e[0"
systemctl enable catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[34m start catalogue \e[0"
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[34mCopy MongoDB repository configuration\e[0"
cp "${script_location}/Files/mongodb.repo" /etc/yum.repos.d/mongodb.repo &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[34m installing mongodb\e[0"
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[34m loading schema\e[0m"
mongo --host localhost </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "Failure"
fi