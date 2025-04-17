# Copyright Xavier Beheydt. All rights reserved.

.DEFAULT_GOAL := up

MKDIR	= mkdir
ifeq ($(OS), Windows_NT)
	WEB_BROWSER = powershell -Command Start-Process
else
	WEB_BROWSER = open
endif
COMPOSE_CMD = docker compose \
				-f docker-compose.yml \
				--env-file .env/dolibarr.env

# Here are default services allowed to start by default
SERVICES ?= \
	web db

test:
	$(MAKE) --dry-run

.PHONY: up
up:  ## Build and start all or specific services
	$(COMPOSE_CMD) up -d ${SERVICES}

.PHONY: down
down:  ## Stop and remove all or specific services
	$(COMPOSE_CMD) down ${SERVICES}

.PHONY: stop
stop:  ## Stop all or specific services
	$(COMPOSE_CMD) stop ${SERVICES}

.PHONY: start
start:  ## Stop all or specific services
	$(COMPOSE_CMD) start ${SERVICES}

.PHONY: restart
restart:  ## Stop all or specific services
	$(COMPOSE_CMD) restart ${SERVICES}

.PHONY: logs
logs:  ## Logs all or specific services
	$(COMPOSE_CMD) logs -f ${SERVICES}

.PHONY: update
update: stop ## Update services
	$(COMPOSE_CMD) pull ${SERVICES}
	$(COMPOSE_CMD) start ${SERVICES}

DB_DUMP ?= 
DB_PASSWORD ?=
.PHONY: db/restore
db/restore:  ## Restauring DB from SQL.GZ file
	$(COMPOSE_CMD) exec -T db mariadb -uroot -p${DB_PASSWORD} dolibarr < ${DB_DUMP}
