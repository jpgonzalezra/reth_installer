#!/bin/bash
set -e

log() {
  echo -e "[\033[1;34m$(date +%T)\033[0m] $1"
}

source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_parsed_dir)

IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
if [ ${#dir_array[@]} -eq 3 ] && [ "${dir_array[2]}" != "scripts" ]; then
    parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
else
    parsed_dir="/${dir_array[0]}/${dir_array[1]}"
fi

# Define color and formatting variables
GREEN='\033[1;32m'
NC='\033[0m' # No Color
BOLD='\033[1m'
NORMAL='\033[0m'
BLUE='\033[1;34m'
ORANGE='\033[1;33m'

# 1) Load the environment variables
log "${ORANGE}${BOLD}Loading environment variables...${NORMAL}"
source "${parsed_dir}/scripts/lib/load_variables.sh"

# 2) Source the script that returns OS and CPU architecture variables
log "${ORANGE}${BOLD}Detecting OS and architecture...${NORMAL}"
source "${parsed_dir}/scripts/lib/get_os_arch.sh"
echo -e "${GREEN}OS:${NC} ${BLUE}$OS${NC}"
echo -e "${GREEN}CPU architecture:${NC} ${BLUE}$ARCH ($ARCH_RAW)${NC}"

# 3) Setup UFW
log "${ORANGE}${BOLD}Setting up UFW...${NORMAL}"
if [[ -f "${parsed_dir}/scripts/setup_ufw.sh" ]]; then
  "${parsed_dir}/scripts/setup_ufw.sh"
  log "${GREEN}UFW setup completed.${NC}"
else
  log "${RED}Missing script: setup_ufw.sh${NC}"
  exit 1
fi

# 4) Setup Nginx
log "${ORANGE}${BOLD}Setting up Nginx...${NORMAL}"
if [[ -f "${parsed_dir}/scripts/setup_nginx.sh" ]]; then
  sudo "${parsed_dir}/scripts/setup_nginx.sh"
  log "${GREEN}Nginx setup completed.${NC}"
else
  log "${RED}Missing script: setup_nginx.sh${NC}"
  exit 1
fi

# 6) Download snapshots if needed
if [[ $SYNC_FROM == "merkle" ]]; then
  echo -e "${ORANGE}${BOLD}Sync mode:${NC} ${BLUE}${SYNC_FROM}${NC}."
  echo -e "${ORANGE}${BOLD}Downloading snapshots...${NORMAL}"
  "${parsed_dir}/scripts/download_snapshot.sh"
  echo -e "${GREEN}${BOLD}Snapshots Downloaded!${NORMAL}"
elif [[ $SYNC_FROM == "chain" ]]; then
  # we don't actually need to do anything here, but we can print a message since reth and lighthouse will start syncing on launch
  echo -e "${ORANGE}${BOLD}Sync mode:${NC} ${RED}${SYNC_FROM}${NC}."
fi

echo -e "${ORANGE}${BOLD}Starting reth & Lighthouse...${NORMAL}"
if ! sudo "${parsed_dir}/scripts/setup_services.sh"; then
  log "${RED}Failed to start services.${NC}"
  exit 1
fi
echo -e "${GREEN}reth & Lighthouse started.${NC}"

echo -e "${GREEN}${BOLD}Script execution completed.${NORMAL}"

# Post Install
sudo "${parsed_dir}/scripts/post_install.sh"