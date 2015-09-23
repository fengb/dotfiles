#!/bin/bash

DOCKER_NAME=${1:-dev}
docker-machine start "$DOCKER_NAME" >&-

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  docker-machine env "$DOCKER_NAME"
else
  eval "$(docker-machine env "$DOCKER_NAME")"
fi
