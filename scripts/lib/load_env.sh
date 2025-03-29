#!/bin/bash

set -a

source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

# Load .env
if [[ -f "${parsed_dir}/.env" ]]; then
  source "${parsed_dir}/.env"
else
  echo ".env file not found at ${parsed_dir}/.env"
fi

set +a