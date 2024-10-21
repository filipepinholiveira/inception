# Dockerfile - Redis
FROM debian:bullseye

# Install necessary packages
RUN apt update -y && \
    apt install -y \
        redis-server \
    && rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

# Copy the necessary files
COPY ./tools/entry.sh /tmp/entry.sh
RUN mkdir -p /etc/redis
RUN mv /etc/redis/redis.conf /etc/redis/redisBakcup.conf
COPY ./conf/redis.conf /etc/redis/redis.conf

# Set permissions
RUN chmod 755 /tmp/entry.sh
RUN chmod 755 /etc/redis/redis.conf

# Set the entrypoint script as the entry point for the container
ENTRYPOINT ["/bin/bash", "/tmp/entry.sh"]
