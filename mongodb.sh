script_location=${pwd}


cp ${script_location}/Files/mongod.repo /etc/yum.repos.d/mongodb.repo

dnf install mongodb-org -y

systemctl enable mongod
systemctl start mongod

sed -e 's/127.0.0.0/0.0.0.0' /etc/mongod.conf
systemctl restart mongod