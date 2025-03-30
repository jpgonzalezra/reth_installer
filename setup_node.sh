#!/bin/bash
set -e

log() {
  echo -e "[\033[1;34m$(date +%T)\033[0m] $1"
}

source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

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

  if [[ -f "$SNAPSHOT_PATH" ]]; then
    echo -e "${GREEN}Using local snapshot: $SNAPSHOT_PATH${NC}"
    SNAPSHOT_TO_EXTRACT="$SNAPSHOT_PATH"
  else
    echo -e "${ORANGE}${BOLD}Downloading snapshot...${NORMAL}"
    "${parsed_dir}/scripts/download_snapshot.sh"
    SNAPSHOT_TO_EXTRACT="reth-latest.tar.zst"
    echo -e "${GREEN}${BOLD}Snapshot Downloaded!${NORMAL}"
  fi

  if [[ -d "$TARGET_PROJECT_ROOT/db" ]]; then
    echo -e "${GREEN}Snapshot already extracted at: $TARGET_PROJECT_ROOT${NC}"
  else
    echo -e "${ORANGE}${BOLD}Extracting snapshot to:${NC} $TARGET_PROJECT_ROOT"
    if ! command -v unzstd &> /dev/null; then
      echo "unzstd could not be found. Please install zstd."
      exit 1
    fi
    tar -v --use-compress-program=unzstd -xf reth-latest.tar.zst -C "$TARGET_PROJECT_ROOT" | tee extract.log
    echo -e "${GREEN}Snapshot restored successfully to: $TARGET_PROJECT_ROOT${NC}"
  fi

elif [[ $SYNC_FROM == "chain" ]]; then
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