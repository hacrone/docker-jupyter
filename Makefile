.PHONY: help

CERT_PATH = ./ssl-certs
PASSWORD = password
TOKEN = $(shell docker run jupyter_datascience-notebook python3 -c "from notebook.auth import passwd; print(passwd('$(PASSWORD)'))")

help:
	# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Start all services
	docker-compose -f docker-compose.yml up -d
stop: ## Stop all services
	docker-compose -f docker-compose.yml stop
down: ## Tear down all services
	docker-compose -f docker-compose.yml down
clean:  ## Remove all services
	docker-compose -f docker-compose.yml down --rmi all
build: ## Force rebuild container
	docker-compose -f docker-compose.yml up -d --build --force-recreate
bash:
	docker exec -it jupyter_notebook bash

install-setup:
	mkdir -p $(CERT_PATH)
	@openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(CERT_PATH)/jupyter.key -out $(CERT_PATH)/jupyter.crt -subj "/C=MY/ST=KL/CN=/emailAddress="

install: install-setup build ## First time installation
	@sed -i '/^ACCESS_TOKEN=/{h;s/=.*/=$(call TOKEN)/};${x;/^$/{s//ACCESS_TOKEN=$(call TOKEN)/;H};x}' .env

