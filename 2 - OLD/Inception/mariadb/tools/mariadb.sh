#!/bin/bash

# Ensure the data directory is initialized

service mariadb start


mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS mydatabase;
CREATE USER IF NOT EXISTS 'fpinho-d'@'%' IDENTIFIED BY 'Vandalose';
GRANT ALL PRIVILEGES ON mydatabase.* TO 'fpinho-d'@'%' IDENTIFIED BY 'Vandalose';
GRANT ALL PRIVILEGES ON mydatabase.* TO 'root'@'%' IDENTIFIED BY 'Vandalose';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Vandalose');
EOF

sleep 5

service mariadb stop

exec "$@" 