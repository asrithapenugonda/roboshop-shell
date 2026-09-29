script_location=$(pwd)
echo -e "\e[33mCopying mongodb repo file \e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

echo -e "\e[33mInstalling mongodb\e[0m"
dnf install mongodb-org -y

echo -e "\e[33mChanging listen address to 0.0.0.0\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e "\e[33mEnable mongodb\e[0m"
systemctl enable mongod

echo -e "\e[33mrestart mongodb\e[0m"
systemctl restart mongod