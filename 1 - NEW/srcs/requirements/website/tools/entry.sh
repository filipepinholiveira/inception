#!/bin/bash

# Set the port number you want to use
cd /tmp
PORT=2000

# Function to handle incoming connections
handle_connection() {
    {
        echo -ne "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n$(cat index.html)"
    } | nc -q 1 -N -l -p $PORT
}

# Start serving static content
handle_connection