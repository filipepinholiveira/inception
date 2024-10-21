
#!/bin/sh

mkdir -p /etc/php/7.4/mods-available/

echo "extension=redis.so" > /etc/php/7.4/mods-available/redis.ini

cat /etc/redis/redisBakcup.conf

# Start redis server
redis-server --protected-mode no
