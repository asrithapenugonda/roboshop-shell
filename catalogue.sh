script_location=$(pwd)
LOG=/tmp/roboshop.log
echo -e "\e[33mDiabale existing NodeJs\e[0m"
dnf module disable nodejs -y &>>$(LOG)
echo -e "\e[33mEnable nojs version 18e[0m"
dnf module enable nodejs:18 -y &>>$(LOG)
echo -e "\e[33mInstalling Zip\e[0m"
dnf install unzip -y &>>$(LOG)

echo -e "\e[33mInstalling nodejs\e[0m"
dnf install nodejs -y &>>$(LOG)

echo -e "\e[33mcreating user roboshop\e[0m"
useradd roboshop &>>$(LOG)
echo -e "\e[33mnew directory called /app\e[0m"
mkdir -p /app &>>$(LOG)

echo -e "\e[33mDownloading catalogue zip file\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>$(LOG)

echo -e "\e[33mDeleteing /app contnet if laredaing exists\e[0m"
rm -rf /app/* &>>$(LOG)
echo -e "\e[33mchanging directory to /app\e[0m"
cd /app &>>$(LOG)
echo -e "\e[33mExtracting catalogue zip file\e[0m"
unzip /tmp/catalogue.zip &>>$(LOG)

echo -e "\e[33mcd to /app\e[0m"

cd /app &>>$(LOG)

echo -e "\e[33mnpm install\e[0m"
npm install &>>$(LOG)

echo -e "\e[33mCopying catalogue systemd file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>$(LOG)

echo -e "\e[33mdaemon reload\e[0m"
systemctl daemon-reload &>>$(LOG)

echo -e "\e[33mEnable Catalogue\e[0m"
systemctl enable catalogue &>>$(LOG)
echo -e "\e[33mstart catalogue\e[0m"
systemctl start catalogue  &>>$(LOG)

echo -e "\e[33mCopying Mongosb repo file\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>$(LOG)

echo -e "\e[33mInstalling mongodb\e[0m"
dnf install mongodb-org -y  &>>$(LOG)

echo -e "\e[33mChanging listen address to 0.0.0.0\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$(LOG)

echo -e "\e[33mDownloading schema\e[0m"
mongosh --host mongodb-dev.robospace.online </app/schema/catalogue.js  &>>$(LOG)