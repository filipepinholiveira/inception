#!/bin/bash

certify_path="/etc/ssl/private/$DOMAIN"

openssl req -x509 -nodes -out $certify_path.csr -keyout $certify_path.key \
            -subj "/C=PT/ST=OPO/L=Porto/O=42/OU=42/CN=$DOMAIN/UID=$DOMAIN_NAME"

echo "
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name www.$DOMAIN $DOMAIN;

    ssl_protocols TLSv1.3;

    ssl_certificate $certify_path.csr;
    ssl_certificate_key $certify_path.key;

    root $WP_DIR;
    index index.html index.php index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ /index.html\$is_args\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
    }
}
" >  /etc/nginx/sites-available/default



#nginx -t

nginx -g "daemon off;"
