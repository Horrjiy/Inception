COMPOSE		:= docker compose -f srcs/docker-compose.yml
USER		:= mpoplow
DATA_DIR	:= /home/$(USER)/data

all: up

prepare:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	
up:	prepare
	$(COMPOSE) up --build

down:
	$(COMPOSE) down

reup: down up

fclean: down
	docker system prune -a --volumes -f
	sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	rm -rf $(DATA_DIR)

.PHONY: all up down reup fclean
