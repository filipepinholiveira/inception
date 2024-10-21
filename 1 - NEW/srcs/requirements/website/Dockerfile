# Dockerfile - wb
FROM debian:bullseye

# Install necessary packages
RUN apt update -y &&\
    apt-get install netcat -y \
    && rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

COPY ./tools/entry.sh /tmp/entry.sh
COPY ./conf/index.html /tmp/index.html

RUN chmod 755 /tmp/entry.sh
RUN chmod 755 /tmp/index.html

ENTRYPOINT ["/bin/bash", "/tmp/entry.sh"]
