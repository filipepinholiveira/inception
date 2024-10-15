#!/bin/bash

service mariadb start
#
sleep 15
# O comando sleep 10 faz com que o script pause a execução por 15 segundos. 
# Isso pode ser útil para dar tempo ao MariaDB para iniciar completamente ou para que qualquer operação anterior tenha tempo 
# suficiente para ser concluída antes de executar o próximo comando.
#
DB_NAME=mydatabase
DB_USER=fpinho-d
DB_PASSWORD=Vandalose
DB_PASS_ROOT=Vandalose
#
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS mydatabase;
CREATE USER IF NOT EXISTS 'fpinho-d'@'%' IDENTIFIED BY 'Vandalose';
GRANT ALL PRIVILEGES ON mydatabase.* TO 'fpinho-d'@'%' IDENTIFIED BY 'Vandalose';
GRANT ALL PRIVILEGES ON mydatabase.* TO 'root'@'%' IDENTIFIED BY 'Vandalose';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Vandalose');
EOF
#
sleep 15
# O comando sleep 10 faz com que o script pause a execução por 15 segundos. 
# Isso pode ser útil para dar tempo ao MariaDB para iniciar completamente ou para que qualquer operação anterior tenha tempo 
# suficiente para ser concluída antes de executar o próximo comando.
#
service mariadb stop
# O comando service mariadb stop vai encerrar o processo do MariaDB, liberando a porta 
# e liberando quaisquer recursos que o banco de dados estava utilizando.
#
#exec mysqld
exec mysqld_safe --user=mysql
# Quando você usa exec $@ em um script, está dizendo ao shell para substituir o processo atual pelo comando que 
# foi passado como argumento ao script. Isso é útil quando você quer que o script inicialize e, em seguida, 
# passe o controle para outro comando ou processo, como um serviço, sem iniciar um novo shell.
