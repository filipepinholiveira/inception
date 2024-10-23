# Dockerfile-wordpress
FROM debian:bullseye

# Install additional dependencies
RUN apt-get update -y && \
    apt-get install -y \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-dev \ 
        curl \
    && rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

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

# Esse Dockerfile cria um contêiner WordPress baseado em Debian, instala as dependências necessárias 
# para executar PHP e configurar o WordPress, copia arquivos de configuração, 
# ajusta permissões e define um script de entrada que gerencia a inicialização do WordPress. 
# Ao usar esse contêiner, você terá um ambiente preparado para rodar uma aplicação WordPress.
