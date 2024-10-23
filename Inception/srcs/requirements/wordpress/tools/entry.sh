#!/bin/bash

# Responsável por configurar o ambiente WordPress e o PHP-FPM em um contêiner ou ambiente similar. 
# Ele automatiza o processo de instalação do WordPress e a criação de usuários, utilizando o WP-CLI (linha de comando do WordPress).

# Este script automatiza a instalação do WordPress usando WP-CLI, 
# configura um usuário administrador e um usuário autor, move as configurações necessárias para PHP-FPM, 
# atualiza plugins e inicia o PHP-FPM. É essencial para garantir que o ambiente de WordPress esteja configurado corretamente e pronto para ser acessado.

sleep 5

mkdir -p $WP_DIR

cd $WP_DIR

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

mv /tmp/wp-config.php $WP_DIR/wp-config.php

if ! wp core is-installed --path=$WP_DIR --allow-root; then
    wp core install --url=$DOMAIN \
    --title=$WP_TITLE \
    --admin_user=$MYSQL_ADMIN_USER \
    --admin_password=$MYSQL_ADMIN_PASSWORD \
    --admin_email=$MYSQL_ADMIN_EMAIL \
    --skip-email \
    --path=$WP_DIR \
    --allow-root
fi

if ! wp user list --field=user_login  --path=$WP_DIR --allow-root | grep -q "^$MYSQL_USER$"; then
      wp user create  $MYSQL_USER $MYSQL_EMAIL \
          --role=author \
          --user_pass=$MYSQL_PASSWORD \
          --path=$WP_DIR \
          --allow-root

fi

mv /tmp/www.conf /etc/php/7.4/fpm/pool.d/www.conf
mkdir /run/php

wp plugin update --all --allow-root

/usr/sbin/php-fpm7.4 -F

