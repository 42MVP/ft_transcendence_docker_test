NAME = ft_transcendence

# Check your env_file
# cp /home/${USER}/ft_transcendence/backend/.env ./

all: build

cp:
	git submodule update --init --recursive
	cp ./.env.sample ./backend/.env
	cp ./nginx.conf ./frontend/nginx.conf
	cp ./[FE]Dockerfile ./frontend/Dockerfile
	cp ./[BE]Dockerfile ./backend/Dockerfile

cp-dev:
	git submodule update --init --recursive
	cd frontend && git switch develop
	cp ./.env.sample ./backend/.env
	cp ./[FE-dev]Dockerfile ./frontend/Dockerfile
	cp ./[BE-dev]Dockerfile ./backend/Dockerfile

build:
	@echo "Building ${NAME} ...\n"
	@mkdir -p /home/${USER}/transcendence/data/upload
	@mkdir -p /home/${USER}/transcendence/data/postgresql
	@mkdir -p /home/${USER}/transcendence/data/postgresql-log
	@docker compose -f ./docker-compose.yml up --build

up:
	@echo "Starting ${NAME} ...\n"
	@mkdir -p /home/${USER}/transcendence/data/upload
	@mkdir -p /home/${USER}/transcendence/data/postgresql
	@mkdir -p /home/${USER}/transcendence/data/postgresql-log
	@docker compose -f ./docker-compose.yml up

start:
	@echo "Starting ${NAME} ...\n"
	@docker compose -f ./docker-compose.yml start

stop:
	@echo "Stopping ${NAME} ...\n"
	@docker compose -f ./docker-compose.yml stop

down:
	@echo "Shuting Down ${NAME} ...\n"
	@docker compose -f ./docker-compose.yml down

clear:
	@su -c 'rm -rf /home/${USER}/transcendence/data'

clean: down clear
	@echo "Cleaning ${name} ...\n"
	@docker volume rm ft_transcendence_test_db_volumes ft_transcendence_test_uploads_volumes

fclean: clear
	@echo "Total Cleaning ...\n"
	@docker stop $$(docker ps -aq)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume rm ft_transcendence_test_db_volumes ft_transcendence_test_uploads_volumes

re: fclean all

.PHONY	: all build down re clean fclean
