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

# No contexto de um Dockerfile, tanto ENTRYPOINT quanto CMD definem o que será executado quando o contêiner for iniciado, 
# mas eles têm diferenças em termos de propósito e comportamento.
# # Com CMD: Se você definir um CMD no Dockerfile, o usuário pode sobrescrever facilmente ao executar o contêiner com outro comando. 
# # O CMD é mais usado para definir um comando padrão que pode ser alterado dinamicamente.
# Com ENTRYPOINT: O comando definido no ENTRYPOINT não será substituído. Qualquer comando fornecido será passado como argumento.


# RESUMO:

# Este Dockerfile cria uma imagem Docker baseada em Debian, instala o MariaDB, configura os diretórios necessários com permissões adequadas, 
# remove o arquivo de configuração padrão e copia um script de entrada (entry.sh). 
# Quando o contêiner é iniciado, o script entry.sh configura o MariaDB e o inicia, tornando-o pronto para uso.