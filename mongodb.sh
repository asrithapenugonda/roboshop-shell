script_location=$(pwd)
LOG=/tmp/roboshop.log
echo -e "\e[33mCopying mongodb repo file \e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$(LOG)

echo -e "\e[33mInstalling mongodb\e[0m"
dnf install mongodb-org -y &>>$(LOG)

echo -e "\e[33mChanging listen address to 0.0.0.0\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$(LOG)

echo -e "\e[33mEnable mongodb\e[0m"
systemctl enable mongod &>>$(LOG)

echo -e "\e[33mrestart mongodb\e[0m"
systemctl restart mongod &>>$(LOG)