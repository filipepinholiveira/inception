#!/bin/bash

echo -e "\e[1;34mStarting MariaDB installation...\e[0m"
echo -e "\e[1;34mStarting MariaDB...\e[0m"
service mariadb start

echo "[client-server]
# Port or socket location where to connect
port = 3306
socket = /run/mysqld/mysqld.sock

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
port = 3306
bind-address = 0.0.0.0
" > /etc/mysql/my.cnf

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then

mysql_secure_installation << EOF
$MYSQL_ROOT_PASSWORD
y
n
y
y
y
y
EOF
echo -e "\e[1;32mMySQL secure installation completed. \e[0m"

fi

echo -e "\e[1;32mMariaDB Starting Setup.\e[0m"


mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_ADMIN_USER'@'%';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
SELECT user, host FROM mysql.user;
FLUSH PRIVILEGES;
exit
EOF

echo -e "\e[1;32mMariaDB setup completed.\e[0m"

echo -e "\e[1;34mStoping MariaDB...\e[0m"

service mariadb stop
echo -e "\e[1;34mStarting MariaDB as a Server...\e[0m"

exec mysqld --datadir=/var/lib/mysql
