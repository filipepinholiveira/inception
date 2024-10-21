# Dockerfile-wordpress
FROM debian:bullseye

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

