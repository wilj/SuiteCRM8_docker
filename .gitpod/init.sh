#!/usr/bin/env bash
set -euxo pipefail

randompassword() {
  openssl rand -base64 $1 | tr '+/' '-_' | tr -d '\n'
}

cd "${GITPOD_REPO_ROOT}"

ROOT_URL=$(gp url 8080)
PMA_ABSOLUTE_URI=$(gp url 8181)

MARIADB_PASSWORD=$(randompassword 30)
INSTALL_DEMO_DATA=yes
ENV_NAME=development

export ROOT_URL INSTALL_DEMO_DATA PMA_ABSOLUTE_URI MARIADB_PASSWORD ENV_NAME

docker-compose build
docker-compose up