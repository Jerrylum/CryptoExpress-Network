#!/bin/bash

# Check if the portal path argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <portal_path>"
  exit 1
fi
export PORTAL_PATH="$1"

export DOCKER_BUILDKIT=0

docker compose up -d
