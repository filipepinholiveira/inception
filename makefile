NAME = inception
SRCS = ./Inception
COMPOSE = /home/filipe-oliveira/Inception/docker-compose.yml
HOST_URL = fpinho-d.42.fr
DATA_DIR = /home/filipe-oliveira/data/

all: conf up

conf:
	@sudo mkdir -p ${DATA_DIR}mariadb_volume/ ${DATA_DIR}wordpress_volume/
	@sudo sed -i '/^127.0.0.1/ s/localhost/localhost fpinho-d.42.fr/' /etc/hosts || true

up:
	sudo docker compose -p ${NAME} --file ${COMPOSE} up --build -d

down:
	sudo docker compose -p ${NAME} down --volumes

start:
	sudo docker compose -p ${NAME} start

stop:
	sudo docker compose -p ${NAME} stop

clean_images:
	@echo "Removing images...\n"
	sudo docker rmi -f $$(sudo docker images -q) || true
	sudo docker builder prune -f

clean: down clean_images

fclean: clean
	@echo "Removing volumes...\n"
	sudo rm -rf ${DATA_DIR}

re: fclean all