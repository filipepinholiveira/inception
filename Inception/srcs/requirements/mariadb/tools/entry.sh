#!/bin/bash
# o script será executado usando o interpretador de comandos Bash

echo -e "\e[1;34mStarting MariaDB installation...\e[0m"
echo -e "\e[1;34mStarting MariaDB...\e[0m"
service mariadb start

echo "[client-server]
port = 3306
# Port or socket location where to connect
# Especifica a porta na qual o MariaDB estará ouvindo
socket = /run/mysqld/mysqld.sock
# Define o local do socket Unix usado para a comunicação local.

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/
# Inclui configurações adicionais que podem estar em diretórios específicos

[mysqld]
port = 3306
bind-address = 0.0.0.0
# Permite conexões de qualquer endereço IP (necessário para funcionar em contêineres).
" > /etc/mysql/my.cnf

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
# Se não existir, ele realiza a configuração inicial do banco de dados

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
#  script reinicia o MariaDB, executando o daemon mysqld, que fica ativo e gerencia o banco de dados. 
# O --datadir especifica o local onde os dados do banco são armazenados


# RESUMO
# automatizar a instalação e configuração inicial do MariaDB dentro de um contêiner Docker. Ele realiza as seguintes tarefas principais:

#     Inicia o serviço MariaDB.
#     Configura o arquivo de configuração (my.cnf) para definir portas, sockets, e permissões de rede.
#     Executa a configuração segura do MariaDB, como definir a senha do usuário root.
#     Cria o banco de dados e os usuários administradores e padrões, concedendo-lhes as permissões necessárias.
#     Para e reinicia o MariaDB como um servidor ativo, pronto para receber conexões.

# Essencialmente, o script prepara e coloca o MariaDB em funcionamento com as configurações básicas necessárias para seu uso dentro do contêiner, 
# sem precisar de intervenção manual.

