# Dockerfile for FTP server
FROM debian:bullseye

# Install FTP server
RUN apt-get update && apt-get install -y \
	vsftpd \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

RUN mv /etc/vsftpd.conf /etc/vsftpd.conf_default

# Copy config file
COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY  ./tools/entry.sh /tmp/entry.sh

# Set permissions
RUN chmod 755 /etc/vsftpd.conf
RUN chmod 755 /tmp/entry.sh

ENTRYPOINT [ "/bin/bash", "/tmp/entry.sh" ]
