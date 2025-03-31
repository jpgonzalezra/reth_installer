#!/bin/bash
set -e

# Detect base path
source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

# Colors for output
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

log() {
  echo -e "[$(date +%T)] $1"
}

# Run setup_server.sh
log "Running server setup..."
if ! sudo "${parsed_dir}/setup_server.sh"; then
  log "${RED}Error: setup_server.sh failed.${NC}"
  exit 1
fi
log "${GREEN}Server setup completed.${NC}"

# Run setup_node.sh
log "Running node setup..."
if ! sudo "${parsed_dir}/setup_node.sh"; then
  log "${RED}Error: setup_node.sh failed.${NC}"
  exit 1
fi
log "${GREEN}Node setup completed.${NC}"

log "${GREEN}Full installation completed successfully.${NC}"