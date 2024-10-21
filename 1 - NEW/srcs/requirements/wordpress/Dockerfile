# Dockerfile-wordpress
FROM debian:bullseye

# Install additional dependencies
RUN apt-get update -y && \
    apt-get install -y \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-dev \ 
        php-redis \
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
