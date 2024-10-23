# Define default directory path and hostname
DIR_PATH ?= /home/filipe-oliveira/data

all: up

dir:
	sudo mkdir -p $(DIR_PATH)/mariadb
	sudo mkdir -p $(DIR_PATH)/wordpress

up: dir
	sudo docker compose -f srcs/docker-compose.yml up --build -d

down:
	sudo docker compose -f srcs/docker-compose.yml down

clean: down
	-@sudo docker volume ls -q | xargs -r sudo docker volume rm -f 2>&1


fclean: clean
	-@sudo docker images -qa | xargs -r sudo docker rmi 2>&1
	@sudo docker system prune -af
	@sudo rm -rf $(DIR_PATH)

re: clean up

.PHONY: all re clean fclean wp maria ps dir down up nginx
# Esta linha define as regras como "não arquivos". Isso significa que mesmo que um arquivo com o nome de uma das regras exista, 
# make irá sempre executar a regra em vez de verificar se ela está atualizada.
