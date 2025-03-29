#!/bin/bash

set -a

source "${BASH_SOURCE%/*}/path.sh"
parsed_dir=$(get_parsed_dir)

# Load .env
if [[ -f "${parsed_dir}/.env" ]]; then
  source "${parsed_dir}/.env"
else
  echo ".env file not found at ${parsed_dir}/.env"
fi

set +a