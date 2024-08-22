script_location=${pwd}


cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y

systemctl enable mongod
systemctl start mongod

sed -e 's/127.0.0.0/0.0.0.0' /etc/mongod.conf
systemctl restart mongod