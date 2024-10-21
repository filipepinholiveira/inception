# Use an official Debian base image
FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Create a directory for Teeworlds server
WORKDIR /teeworlds

# Download and extract Teeworlds server
RUN wget https://github.com/teeworlds/teeworlds/releases/download/0.7.5/teeworlds-0.7.5-linux_x86_64.tar.gz \
    && tar -xzf teeworlds-0.7.5-linux_x86_64.tar.gz \
    && rm teeworlds-0.7.5-linux_x86_64.tar.gz

# Command to start the Teeworlds server
COPY entry.sh /teeworlds/entry.sh

ENTRYPOINT [ "/bin/bash", "/teeworlds/entry.sh" ]

