#!/usr/bin/env bash
set -euxo pipefail

docker stop $(docker ps -q) || echo "nothing to stop"
docker rm $(docker ps -aq) || echo "nothing to remove"

docker volume rm $(docker volume ls -q)  || echo "nothing to remove"

"${GITPOD_REPO_ROOT}/.gitpod/init.sh"