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
