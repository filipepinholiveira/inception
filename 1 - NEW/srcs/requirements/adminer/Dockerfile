# Dockerfile for adminer
FROM debian:bullseye

# Install adminer
RUN apt-get update && \
	apt-get install -y	\
			wget \
			php7.4 \
			php7.4-mysql

# Copy entry.sh
COPY ./tools/entry.sh /tmp/entry.sh

# Change permission
RUN chmod +x /tmp/entry.sh

ENTRYPOINT ["/tmp/entry.sh"]
