#!/bin/bash

mkdir -p $WP_DIR/adminer

wget "http://www.adminer.org/latest.php" -O $WP_DIR/adminer/index.php

chown -R www-data:www-data $WP_DIR/adminer
chmod 755 $WP_DIR/adminer/adminer.php



rm -rf $WP_DIR/adminer/index.html

ls $WP_DIR/adminer

cd $WP_DIR/adminer

php -S 0.0.0.0:80
