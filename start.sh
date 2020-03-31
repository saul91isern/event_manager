#!/bin/sh

# Environment variables used in CI build
export APP_VERSION="0.1.0"
export CURRENT_UID="$(id -u):$(id -g)"
export COMPOSE_FILE="ci/docker-compose.yml"
export CI_PROJECT_DIR="$(pwd)"

docker-compose up service