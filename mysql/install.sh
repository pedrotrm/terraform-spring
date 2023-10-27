#!/bin/bash

sleep 120
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y mysql-common libevent-core-2.1-6 mysql-client-5.7 mysql-server-core-5.7 libhtml-template-perl mysql-server-5.7 
sudo mysql < /home/ubuntu/mysql/script/user.sql
sudo mysql < /home/ubuntu/mysql/script/schema.sql
sudo mysql < /home/ubuntu/mysql/script/data.sql
sudo cp -f /home/ubuntu/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
sleep 20
