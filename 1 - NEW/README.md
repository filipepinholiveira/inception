# Inception

## Table of Contents

- [Setting up Shared Folder](#setting-up-shared-folder-in-ubuntu-vm-with-virtualbox-guest-additions)
  - [Install VirtualBox Guest Additions](#install-virtualbox-guest-additions)
  - [Update and Install Required Packages](#update-and-install-required-packages)
  - [Mount the Guest Additions](#try-to-mount-the-guest-additions)
  - [Create a Shared Folder](#create-a-shared-folder)
  - [Mount the Shared Folder](#mount-the-shared-folder)
  - [Mount a Permanent Shared Folder](#mount-a-permanent-shared-folder)

- [Inception](#inception-1)
  - [Install all the requirements](#install-all-the-requirements)
    - [Uninstall all the previous packages](#uninstall-all-the-previous-packages)
  - [Docker-Compose](#docker-compose)
    - [Commands](#commands)
    - [File](#file)
  - [Mariadb](#mariadb)
    - [Install](#install)
    - [Flags](#flags)
    - [Commands](#commands-1)
    - [Config](#config)
    - [Example of a Docker File](#example-of-a-docker-file)
    - [Example of an Entrypoint.sh](#example-of-entrypoint.sh)
  - [Wordpress](#wordpress)
    - [Install](#install-1)
    - [Config](#config-1)
    - [Example of a Docker File](#example-of-a-docker-file_1)
    - [Example of an Entrypoint.sh](#example-of-entrypoint.sh_1)
  - [Nginx](#nginx)
    - [Install](#install-2)
    - [Config](#config-2)
    - [Example of a Docker File](#example-of-a-docker-file_2)
    - [Example of an Entrypoint.sh](#example-of-entrypoint.sh_2)

-------------------------------------------------------------------------

## Setting up Shared Folder in Ubuntu VM with VirtualBox Guest Additions

### Install VirtualBox Guest Additions

1. Start your Ubuntu VM.
2. In the VirtualBox menu, navigate to "Devices" > "Insert Guest Additions CD image."

### Update and Install Required Packages

```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y \
	 build-essential \
	 dkms \
	 linux-headers-$(uname -r)
```

# Try to mount the Guest Additions

```bash
mkdir /media/cdrom
sudo mount /dev/cdrom /media/cdrom
cd /media/cdrom
sudo ./VBoxLinuxAdditions.run
sudo shutdown -r now
```

if this do not work means that the machine already mount the cd
so try to enter in the next path to install the Guest Additions

```bash
cd /media/$(hostname)
cd /VBox_GAs_<version>
sudo ./VBoxLinuxAdditions.run
sudo shutdown -r now
```

### Create a Shared Folder
- In VirtualBox, select your VM.
- Navigate to "Settings" > "Shared Folders."
- Add a new shared folder, specifying the folder path on your host machine.

### Mount the Shared Folder

#### Change the name Shared with the name of your Shared Folder

```bash
sudo mkdir /mnt/shared
sudo mount -t vboxsf Shared /mnt/shared/
cd /mnt/shared
```

### Mount a Permenent Shared Folder

#### open the file with sudo

```bash
sudo nano /etc/fstab
```
#### Add the Next Line

```bash
<Shared_Folder_Name> /mnt/shared vboxsf defaults 0 0
```
#### Save the file and try this

```bash
systemctl daemon-reload # reload the config of fstab
sudo mount -a
```
-------------------------------------------------------------------------

# Inception

**Host Setup**

- In order to test the website we need to add the domain to the `/etc/hosts` to test if the websit is working.

## Install  all the requirements

### Uninstall all the previous packages

```bash
 for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

### The git and the code are not important for this project but its a way to mantain it

```bash
#!/bin/bash

sudo apt-get update	-y > /dev/null
sudo apt-get install 	-y \
			build-essential \
			dkms \
			linux-headers-$(uname -r) \
		     	ca-certificates \
			curl \
			gnupg \
			git > /dev/null # this is not necessary

sudo snap install --classic code > /dev/null  # this is not necessary

# create a new directory named keyrings in the /etc/apt directory and set its permissions to 755.
sudo install -m 0755 -d /etc/apt/keyrings > /dev/null

# This command downloads the Docker apt key from the Docker website, decrypts it, and saves it to the file /etc/apt/keyrings/docker.gpg
# this is needed to apt trust the docker package
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.gpg > /dev/null

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update	-y > /dev/null
sudo apt-get upgrade	-y > /dev/null

# Install the Docker Packeges
sudo apt-get install 	-y \
			docker-ce \
			docker-ce-cli \
			containerd.io \
			docker-buildx-plugin \
			docker-compose-plugin > /dev/null

sudo service docker start > /dev/null
sudo docker run hello-world

```

-------------------------------------------------------------------------

## Docker-Compose

### Commands

**Building and Managing Images:**

- `docker build`: Build an image from a Dockerfile.
- `docker pull`: Pull an image or a repository from a registry.
- `docker push`: Push an image or a repository to a registry.
- `docker images` or `docker image ls`: List all images on your system.
- `docker rmi`: Remove one or more images.

**Running Containers:**

- `docker run`: Create and start a container from an image.
- `docker ps`: List all running containers.
- `docker ps -a` or `docker container ls -a`: List all containers (including stopped ones).
- `docker start`: Start a stopped container.
- `docker stop`: Stop a running container.
- `docker restart`: Restart a container.
- `docker exec`: Run a command in a running container.

**Managing Containers:**

- `docker rm`: Remove one or more containers.
- `docker rename`: Rename a container.
- `docker logs`: View the logs of a container.
- `docker top`: Display the running processes of a container.

**Network and Connectivity:**

- `docker network ls`: List all networks.
- `docker network create`: Create a network.
- `docker network connect`: Connect a container to a network.
- `docker network disconnect`: Disconnect a container from a network.
- `docker port`: List port mappings or open ports on a container.

**Volumes:**

- `docker volume ls`: List all volumes.
- `docker volume create`: Create a volume.
- `docker volume inspect`: Display detailed information about a volume.

**Docker Compose:**

- `docker-compose up`: Start services defined in a `docker-compose.yml` file.
- `docker-compose down`: Stop and remove containers, networks, and volumes defined in a `docker-compose.yml` file.
- `docker-compose ps`: List containers and their status in a Docker Compose setup.
- `docker-compose logs`: View the logs of containers in a Docker Compose setup.

**Registry and Authentication:**

- `docker login`: Log in to a Docker registry.
- `docker logout`: Log out from a Docker registry.

**System Information:**

- `docker info`: Display system-wide information.
- `docker version`: Show the Docker version information.

**Cleaning Up:**

- `docker system prune`: Remove all stopped containers, dangling images, and unused networks and volumes.

### File

``` Docker-Compose.yml
services:
    mariadb:
        container_name: mariadb
        build:
            context: ./requirements/mariadb
            dockerfile: Dockerfile
        env_file:
            - .env
        restart: unless-stopped
        image: mariadb
        volumes:
            - mariadb_data:/var/lib/mysql
        ports:
            - "3306:3306"
        networks:
            - myNetwork
    nginx:
        container_name: nginx
        depends_on:
            - wordpress
        build:
            context: ./requirements/nginx
            dockerfile: Dockerfile
        restart: unless-stopped
        env_file:
            - .env
        image: nginx
        volumes:
            - wordpress_data:/var/www/html
        ports:
            - "443:443"
        networks:
            - myNetwork
    wordpress:
        container_name: wordpress
        depends_on:
            - mariadb
        build:
            context: ./requirements/wordpress
            dockerfile: Dockerfile
        restart: unless-stopped
        image: wordpress
        env_file:
            - .env
        volumes:
            - wordpress_data:/var/www/html
        ports:
            - "9000:9000"
        networks:
            - myNetwork

networks:
    myNetwork:
        name: inception
        driver: bridge

volumes:
  mariadb_data:
    name: mariadb_data
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/tmp/data/mariadb'
  wordpress_data:
    name: wordpress_data
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/tmp/data/wordpress'
```

-------------------------------------------------------------------------

## Mariadb

### Install

``` bash
sudo apt-get update -y
sudo apt-get install -y \
             mariadb-server
```

### Flags

- ``-h HOST``: Specify the hostname or IP address of the MariaDB server.
- ``-P PORT``: Specify the port number on which MariaDB is listening.
- ``-u USERNAME``: Specify the MariaDB username for authentication.
- ``-p``: Prompt for the password.

### Commands

**Connecting to the Database**

```bash
mysql -h HOST -P PORT -u USERNAME -p
mysql -h HOST -P PORT -u USERNAME -p DATABASE
```

**Database Management**

- Create a Database:
```sql
CREATE DATABASE IF NOT EXISTS your_database;
```

- Use a Database:
 ```sql
USE your_database;
```

- List Databases:
```sql
SHOW DATABASES;
```

**User Management**

- Create a User:
```sql
CREATE USER 'your_user'@'%' IDENTIFIED BY 'your_password';
```

- Grant Privileges:
```sql
GRANT ALL PRIVILEGES ON your_database.* TO 'your_user'@'%';
```

- Show User Hosts:
```sql
SELECT user, host FROM mysql.user;
```

**Table Operations**

- Create a Table:
```sql
CREATE TABLE your_table (column1 datatype, column2 datatype, ...);
```

- Insert Data into a Table:
```sql
INSERT INTO your_table (column1, column2, ...) VALUES (value1, value2, ...);
```

- Select Data from a Table:
```sql
SELECT * FROM your_table;
```

- Exit
```sql
Exit
```

### Config

**Configuration File (my.cnf)**

- this script generates a custom configuration file (.cnf) to define MariaDB settings.

```bash
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

```

**Secure Installation**

- The script checks if the specified database directory exists. If not, it runs the mysql_secure_installation script for enhanced security

```bash
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

```

**Database and User Setup**

- The script proceeds to create the database and users necessary for WordPress

```bash
echo -e "\e[1;32mMariaDB Starting Setup.\e[0m"

mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER '$MYSQL_ADMIN_USER'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_ADMIN_USER'@'%';
FLUSH PRIVILEGES;
exit
EOF

```

**Finalization**

- The script concludes by stopping MariaDB, then starting it as a server in a way to prevent the docker to restarting

```bash
exec mysqld --datadir=/var/lib/mysql
```

### Example of a Docker File

```Dockerfile
# Dockerfile-mariadb
FROM debian:bullseye

# Install MariaDB
RUN apt-get update && \
    apt-get install -y\
            mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

# Remove the default MySQL configuration
RUN rm -f /etc/mysql/my.cnf

# Copy the entrypoint script
COPY ./tools/entry.sh /tmp/entry.sh
RUN chmod 755 /tmp/entry.sh

# Set the entrypoint script as the entry point for the container
ENTRYPOINT ["/bin/bash", "/tmp/entry.sh"]

```

### Example of an Entrypoint.sh

```bash
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
CREATE USER '$MYSQL_ADMIN_USER'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
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

```


---------------------------------------------------------------------------

## Wordpress

### Install

- In order to use the Wordpress we need to Intall some packages to work with Nginx

```bash
sudo apt update -y && \
sudo apt install -y \
        php7.4-fpm \
        php7.4-mysql \
        curl
```

### Config

**wp-config.php**

- Wordpress Config in order to communicate with our database

```php
<?php

define( 'DB_NAME', getenv('MYSQL_DATABASE') );
define( 'DB_USER', getenv('MYSQL_ADMIN_USER') );
define( 'DB_PASSWORD', getenv('MYSQL_ADMIN_PASSWORD') );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define('AUTH_KEY',         'nynZN@p%~s+VI2R}}wUJ[QIeCFk-DkNI)A:h=badn/,4xBpfAt,y(#,N}hnGAk [');
define('SECURE_AUTH_KEY',  '5}`z5X=]VN(~tp&pMG(~cwLoxIC`cnRqAP5Yf|f%^aN9-H+1O!|feL}slY#laZF9');
define('LOGGED_IN_KEY',    '_CI;<.-Yb#q6/C)w5BO*Qw!+rrp}umu+0bg|E,p<zdg T#E.|.<{|(BDczhL<#v(');
define('NONCE_KEY',        'M3eR`S~+F[Ie%NyZ$0x}(8:+FEp{cI?}J>J-j)cXU_Vno#,ylXd3|y`;#,fNlzX5');
define('AUTH_SALT',        'F)vM!awJo~0[A :hBe^Er1fv6uE0|*N*c+5>CYGRv` )E+@sk(&j?~@MX/d>!Tz~');
define('SECURE_AUTH_SALT', 'VK8-jb3.JA$|8]m&0TSoG#4nQ>+e1kB}A&ZYPzzJ.Ol#3  |tJlN.,IlL}.TAX5#');
define('LOGGED_IN_SALT',   'HcgLD)(7|e]E@1nh(|i~*dK+Pj*#T;rc+SR1*+{C%gQAD7is>xHT6*6O]b(J;G#m');
define('NONCE_SALT',       '=5RgOJnbZn:z7C&bv-x:O]$6cnkv.SRz!2Us F~Uvn:$PuKo8he`Wh,r!-p3x`h1');

$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

```

**.conf**

- Configuration of php-fpm in other to define is Settings

```.conf
[www]
user = www-data
group = www-data
listen = wordpress:9000
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 75
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
pm.process_idle_timeout = 10s
clear_env = no
```

**Download Wordpress**

- Download Wordpress to a specific folder like `/var/www/html` and make shure that this folder exists.
- Dowload `wp-cli` and add it to the `/usr/local/bin/` as **wp** in order to config wordpress

```bash
mkdir -p /var/www/html
rm -rf /var/www/html/*
cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp core download --allow-root
```

**Config**

- Config the php7.4-fpm to the config folder adding the file to `/etc/php/7.4/fpm/pool.d/`
- Add the `wp-config.php` to your wordpress folder
- `wp core install` install wordpress with some specific parameters
- `wp user create` Create a user

```bash
mv /tmp/wp-config.php /var/www/html/wp-config.php
mv /tmp/www.conf /etc/php/7.4/fpm/pool.d/www.conf

wp core install --url=$DOMAIN \
                --title=$WP_TITLE \
                --admin_user=$MYSQL_ADMIN_USER \
                --admin_password=$MYSQL_ADMIN_PASSWORD \
                --admin_email=$MYSQL_ADMIN_EMAIL \
                --skip-email \
                --path='/var/www/html' \
                --allow-root

wp user create  $MYSQL_USER $MYSQL_EMAIL \
                --role=author \
                --user_pass=$MYSQL_PASSWORD \
                --path='/var/www/html' \
                --allow-root
```

**Start php-fpm7.4**

- Create a folder to the php-fpm7.4 sockets and start the php-fpm7.4 in foreground to prevent the docker from a restart.

```bash
mkdir /run/php
/usr/sbin/php-fpm7.4 -F
```

### Example of a Docker File

```Dockerfile
# Dockerfile-wordpress
FROM debian:bullseye

# Install necessary packages
RUN apt update -y && \
    apt install -y \
        php7.4-fpm \
        php7.4-mysql \
        curl \
    && rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

# Create necessary directories and set permissions
RUN mkdir -p /var/www/html

# Copy the necessary files
COPY ./conf/www.conf /tmp/www.conf
COPY ./tools/entry.sh /tmp/entry.sh
COPY ./conf/wp-config.php /tmp/wp-config.php

# Set permissions
RUN chmod 755 /tmp/www.conf
RUN chmod 755 /tmp/entry.sh
RUN chmod 755 /tmp/wp-config.php

# Set the entrypoint script as the entry point for the container
ENTRYPOINT ["/bin/bash", "/tmp/entry.sh"]
```

### Example of an Entrypoint.sh

```bash
#!/bin/bash

rm -rf /var/www/html/*

cd /var/www/html

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

mv /tmp/wp-config.php /var/www/html/wp-config.php

if ! wp core is-installed --path='/var/www/html' --allow-root; then
    wp core install --url=$DOMAIN \
    --title=$WP_TITLE \
    --admin_user=$MYSQL_ADMIN_USER \
    --admin_password=$MYSQL_ADMIN_PASSWORD \
    --admin_email=$MYSQL_ADMIN_EMAIL \
    --skip-email \
    --path='/var/www/html' \
    --allow-root
fi

if ! wp user list --field=user_login  --path='/var/www/html' --allow-root | grep -q "^$MYSQL_USER$"; then
      wp user create  $MYSQL_USER $MYSQL_EMAIL \
          --role=author \
          --user_pass=$MYSQL_PASSWORD \
          --path='/var/www/html' \
          --allow-root

fi


mv /tmp/www.conf /etc/php/7.4/fpm/pool.d/www.conf

mkdir /run/php

/usr/sbin/php-fpm7.4 -F


```

-------------------------------------------------------------------------

## Nginx

### Install

```bash
sudo apt-get update
sudo apt-get install -y \
        nginx \
        openssl
```

### Config

**Create Certificates**

- Create both Certificates with some specific parameters to be present in the browser

```bash
certify_path="/etc/ssl/private/Certificate"

openssl req -x509 -nodes -out $certify_path.csr -keyout $certify_path.key \
            -subj "/C=PT/ST=OPO/L=Porto/O=42/OU=42/CN=<DOMAIN>/UID=<DOMAIN_NAME>"
```

**Nginx Config**

- Config nginx to a file inside this folder `/etc/nginx/sites-available/` whith the server config

```
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name www.example.com example.com;

    ssl_protocols TLSv1.3;

    ssl_certificate $certify_path.csr;
    ssl_certificate_key $certify_path.key;

    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;

    location ~ [^/]\.php(/|$) {
        try_files \$uri =404;
        fastcgi_pass <Lisen parameter inside php-fpm>;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
```

- You can check your config with `nginx -t` and start Nginx web server with `nginx -g "daemon off;"`

### Example of a Docker File

- This example of dockerfile is using an nginx image to make the container as lightweight as possible.
  But could be use another type of image like a version of Debian.

```Dockerfile
# Dockerfile-wordpress
FROM debian:bullseye

# Exposure of ports
EXPOSE 443

# Install necessary packages
RUN apt -y update && \
	apt install -y \
		nginx \
		openssl \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

# Copy the entrypoint script
COPY ./tools/entry.sh /tmp/entry.sh
RUN chmod 755 /tmp/entry.sh

# Set the entrypoint script as the entry point for the container
ENTRYPOINT ["/bin/bash", "/tmp/entry.sh" ]
```

### Example of an Entrypoint.sh

```bash
#!/bin/bash

certify_path="/etc/ssl/private/$DOMAIN"

openssl req -x509 -nodes -out $certify_path.csr -keyout $certify_path.key \
            -subj "/C=PT/ST=OPO/L=Porto/O=42/OU=42/CN=$DOMAIN/UID=$DOMAIN_NAME"

echo "server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name www.$DOMAIN $DOMAIN;

    ssl_protocols TLSv1.3;

    ssl_certificate $certify_path.csr;
    ssl_certificate_key $certify_path.key;

    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;

    location ~ [^/]\.php(/|$) {
        try_files \$uri =404;
        fastcgi_pass wordpress:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
" >  /etc/nginx/sites-available/default

nginx -t

nginx -g "daemon off;"

```


