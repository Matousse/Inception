all: setup up

setup:
	@printf "Creating data directories...\n"
	@sudo mkdir -p /home/dmathis/data/wordpress
	@sudo mkdir -p /home/dmathis/data/mariadb
	@sudo chmod 755 /home/dmathis/data/wordpress
	@sudo chmod 755 /home/dmathis/data/mariadb

up:
	@printf "Starting Docker containers...\n"
	@docker-compose -f srcs/docker-compose.yml up --build -d

down:
	@printf "Stopping Docker containers...\n"
	@docker-compose -f srcs/docker-compose.yml down

clean: down
	@printf "Cleaning up Docker resources...\n"
	@docker system prune -af
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf /home/dmathis/data/wordpress/*
	@sudo rm -rf /home/dmathis/data/mariadb/*

fclean: clean
	@printf "Deep cleaning...\n"
	@docker system prune -af --volumes
	@sudo rm -rf /home/$$USER/data

re: fclean all

.PHONY: all up down clean fclean re
