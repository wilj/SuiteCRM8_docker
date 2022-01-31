#!/usr/bin/env bash
set -euxo pipefail

if [ -f .env ]; then
    echo ".env already exists, skipping creation"
else
    cp localhost.env .env
fi

docker-compose build
docker-compose up