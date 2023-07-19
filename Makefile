NAME = ft_transcendence

# Check your env_file
# cp ${HOME}/ft_transcendence/backend/.env ./

all: build

# NOTE - ft_transcendece에 정식 등록 전까지 make cp 대체
cp:
	git submodule update --init --recursive
	cp ./.env.sample ./backend/.env
	cp ./nginx.conf ./frontend/nginx.conf
	cp ./Dockerfile.front ./frontend/Dockerfile
	cp ./Dockerfile.back ./backend/Dockerfile

dev:
	@echo "🏗️  Building ${NAME}-dev ...\n"
	@cd frontend && git switch develop
	@mkdir -p ${HOME}/transcendence/data/upload
	@mkdir -p ${HOME}/transcendence/data/postgresql
	@mkdir -p ${HOME}/transcendence/data/postgresql-log
	@docker compose -f .docker/docker-compose.yml up --build

build:
	@echo "🏗️  Building ${NAME} ...\n"
	@mkdir -p ${HOME}/transcendence/data/upload
	@mkdir -p ${HOME}/transcendence/data/postgresql
	@mkdir -p ${HOME}/transcendence/data/postgresql-log
	@docker compose -f docker-compose.yml up --build

up:
	@echo "🔺  Starting ${NAME} ...\n"
	@mkdir -p ${HOME}/transcendence/data/upload
	@mkdir -p ${HOME}/transcendence/data/postgresql
	@mkdir -p ${HOME}/transcendence/data/postgresql-log
	@docker compose -f ./docker-compose.yml up

dev-up:
	@echo "🔺  Starting ${NAME}-dev ...\n"
	@mkdir -p ${HOME}/transcendence/data/upload
	@mkdir -p ${HOME}/transcendence/data/postgresql
	@mkdir -p ${HOME}/transcendence/data/postgresql-log
	@docker compose -f .docker/docker-compose.yml up

start:
	@echo "💨  Starting ${NAME} ...\n"
	@docker compose -f ./docker-compose.yml start

stop:
	@echo "🛑  Stopping ${NAME} ...\n"
	@docker compose -f ./docker-compose.yml stop

down:
	@echo "🔻  Shuting Down ${NAME} ...\n"
	@docker compose -f ./docker-compose.yml down

dev-down:
	@echo "🔻  Shuting Down ${NAME}-dev ...\n"
	@docker compose -f .docker/docker-compose.yml down

stop-all:
	@docker stop $$(docker ps -aq)

clear:
	@sudo rm -rf ${HOME}/transcendence

clean: down
	@echo "🧹  Cleaning ${name} ... (keep images)\n"
	@docker volume rm ft_tsen_db_volumes ft_tsen_uploads_volumes

fclean: clean
	@echo "🧼  Total Cleaning ...\n"
	@docker system prune --all --force --volumes
	@docker network prune --force
	@echo "📢  To delete data: make clear\n"

re: fclean all

.PHONY	: all build down re clean fclean
