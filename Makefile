SHELL:=/bin/bash

DOCKER_COMPOSE="docker-compose"
ifndef $DOCKER_COMPOSE
  DOCKER_COMPOSE="docker compose"
endif

SERVICE_NAME="traefik-local"

.PHONY: local-ca
local-ca: ## install local CA mkcert certificates
	$(shell eval $(DOCKER_COMPOSE) exec $(SERVICE_NAME) mkcert -install)

.PHONY: cert
cert: ## generate .local certificate and add entry to traefik certificates.toml file
	@scripts/add-domain.sh

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help