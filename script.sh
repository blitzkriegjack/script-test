#!/bin/bash
if [ -f /usr/bin/mongod ]; then
  exit
else
  wget -qO- https://www.mongodb.org/static/pgp/server-4.0.asc | apt-key add
  echo deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse > /etc/apt/sources.list.d/mongodb-org.list
  apt update && apt upgrade -y
  apt install mongodb-org -y
  apt update && apt upgrade -y
  apt autoremove && apt clean
  mkdir /data /data/db
  systemctl enable mongod
  service mongod start
  mongo "admin" --eval "db.createUser({'user':'webapp','pwd':'webapptest123','roles': ['userAdminAnyDatabase','readWriteAnyDatabase']})"
  echo ' ' >> /etc/mongod.conf
  echo 'security:' >> /etc/mongod.conf
  echo '  authorization: enabled' >> /etc/mongod.conf
  sed -i 's/127.0.0.1/$1/g' /etc/mongod.conf
  service mongod restart
fi
