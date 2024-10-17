#!/bin/bash

# Responsável por configurar e iniciar uma instalação do WordPress em um ambiente Docker ou outro servidor que utilize PHP e MariaDB como banco de dados

chown -R www-data:www-data /var/www/*
# Altera o proprietário e grupo dos arquivos no diretório /var/www/ para www-data. 
# Isso é importante porque o servidor web (como Nginx ou Apache) geralmente roda com o usuário www-data 
# e precisa de permissões apropriadas para acessar e modificar os arquivos do WordPress.

chmod -R 755 /var/www/*
# Define as permissões dos arquivos, permitindo que o proprietário possa ler, escrever e executar, e os outros usuários possam ler e executar.

mkdir -p /run/php/
# Cria o diretório necessário para os arquivos de PID (Process ID) do PHP-FPM.

touch /run/php/php7.4-fpm.pid
# Cria o arquivo de PID onde o PHP-FPM pode armazenar o ID do processo em execução.

sed -i "s/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/" "/etc/php/7.4/fpm/pool.d/www.conf"
# sed: Modifica o arquivo de configuração do PHP-FPM (www.conf), alterando o socket de comunicação para a porta 9000. 
# Isso permite que o servidor web se comunique com o PHP via essa porta, em vez de usar um socket de arquivo.

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Wordpress: setting up..."

    mkdir -p /var/www/html
    cd /var/www/html
    rm -rf *

    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    if [ ! -f wp-cli.phar ]; then
        echo "Failed to download wp-cli.phar"
        exit 1
    fi
    # Cria o diretório /var/www/html (onde o WordPress será instalado) e limpa seu conteúdo.
    # Baixa o WP-CLI (uma ferramenta de linha de comando para gerenciar instalações WordPress), 
    # e o move para o diretório /usr/local/bin/ para ser executado globalmente.

    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    echo "Downloading Wordpress core..."
    wp core download --allow-root

    while ! mysqladmin ping -hmariadb --silent; do
            echo "Waiting for MariaDb to be ready..."
            sleep 2
    done
    # O script espera até que o banco de dados MariaDB esteja disponível, fazendo verificações a cada 2 segundos.

    echo "Creating wp-config.php..."
    wp config create --allow-root --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=mariadb:3306
    # Cria o arquivo de configuração do WordPress (wp-config.php) usando as variáveis de ambiente para o nome do banco de dados, usuário, senha e host.
    
    echo "Installing Wordpress..."
    wp core install --url="https://$WP_URL" --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email --path="/var/www/html/" --allow-root
    # Instala o WordPress com as informações fornecidas via variáveis de ambiente, como o URL do site, título, nome do administrador e email.

    echo "Creating subscribed user..."
    wp user create $DB_USER filipepinholiveira@gmail.com --role=subscriber --user_pass=$DB_PASS --allow-root
    # Cria um usuário com o papel de subscriber (assinante), utilizando o nome e senha definidos.

    echo "Wordpress: installation complete!"
fi

exec "$@"
# Este comando executa qualquer comando passado como argumento ao script. 
# Isso é comum em scripts Docker, pois o exec substitui o shell atual pelo comando especificado (neste caso, deve iniciar o PHP-FPM e mantê-lo em execução).