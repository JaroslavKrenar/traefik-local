#!/usr/bin/env bash

DOCKER_COMPOSE="docker-compose"
if ! [ -x "$(command -v $DOCKER_COMPOSE)" ]; then
  DOCKER_COMPOSE="docker compose"
fi

SERVICE_NAME="traefik-local"

read -p 'Domain name without .local suffix: ' domain

cert_file="/etc/traefik/certs/${domain}.local.crt"
key_file="/etc/traefik/certs/${domain}.local.key"

# check if the certificate entry already exists in the configuration
if grep -q "${cert_file}" conf/certificates.toml; then
  echo "Certificate entry for '${domain}' already exists in the Traefik configuration"
else

  ${DOCKER_COMPOSE} exec ${SERVICE_NAME} mkcert --cert-file ${domain}.local.crt --key-file ${domain}.local.key ${domain}.local
  # add the new certificate entry to the configuration
  {
          echo ""
          echo "[[tls.certificates]]"
          echo "certFile = \"${cert_file}\""
          echo "keyFile = \"${key_file}\""
  } >> conf/certificates.toml
  echo "Added certificate entry for '${domain}' to the Traefik configuration"
fi
