# Store the current working directory

script_location=$(pwd)
LOG=/tmp/roboshop.log

# Install the required packages

echo -e "\e[41m Disable node js if present[0m\e"
dnf module disable nodejs -y &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[42m enable nodejs 18 version[0m\e"
dnf module enable nodejs:18 -y &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[41m installing Nodejs[0m\e"
dnf install nodejs -y &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[43m Create a user for your application[0m\e"
 useradd roboshop &>>{LOG}
 if ( $?=0 ); then
   echo "success"
 else
   echo "Failure"
 fi

echo -e "\e[44mCreate the application directory[0m\e"
mkdir -p /app &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

ecjo -e "\e[45mDownload the application code[0m\e"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[32m Changing directory to application[0m\e"
 cd /app &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[44m removing content in application [0m\e"
rm -rf /app/* &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[35m unzipping the file[0m\e"
unzip /tmp/catalogue.zip &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi



echo -e "\e[34m Change to the application directory[0m\e"
cd /app &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi

echo -e "\e[43mInstall npm dependencies[0m\e"
 npm install &>>{LOG}
 if ( $?=0 ); then
   echo "success"
 else
   echo "Failure"
 fi

echo -e "\e[34mCopy the service file[0m\e"
 cp "${script_location}/Files/catalogue.service" /etc/systemd/system/catalogue.service &>>{LOG}
 if ( $?=0 ); then
   echo "success"
 else
   echo "Failure"
 fi


echo -e "\e[45mReload systemd and enable/start the service[0m\e"
echo -e "\e[32m daemon reload[0m\e"
systemctl daemon-reload &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[32m enable catalogue[0m\e"
systemctl enable catalogue &>>{LOG}
if ( $?=0 ); then
  echo "success"
else
  echo "Failure"
fi
echo -e "\e[32m start catalogue [0m\e"
 systemctl start catalogue &>>{LOG}
 if ( $?=0 ); then
   echo "success"
 else
   echo "Failure"
 fi


echo -e "\e[42mCopy MongoDB repository configuration[0m\e"
 cp "${script_location}/Files/mongodb.repo" /etc/yum.repos.d/mongodb.repo &>>{LOG}
 if ( $?=0 ); then
   echo "success"
 else
   echo "Failure"
 fi

 echo -e "\e[35m installing mongodb[0m\e"
 yum install mongodb-org-shell -y &>>{LOG}
 if ( $?=0 ); then
   echo "success"
 else
   echo "Failure"
 fi

echo -e "\e[35m loading schema[0m\e"
 mongo --host localhost </app/schema/catalogue.js &>>{LOG}
 if ( $?=0 ); then
   echo "success"
 else
   echo "Failure"
 fi  
