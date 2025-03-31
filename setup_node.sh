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
if [[ "$SYNC_FROM" == "merkle" ]]; then
  echo -e "${ORANGE}${BOLD}Sync mode:${NC} ${BLUE}merkle${NC}"

  # Check if snapshot data already exists
  if [[ -d "$TARGET_PROJECT_ROOT/db" && -d "$TARGET_PROJECT_ROOT/static_files" ]]; then
    echo -e "${GREEN}Snapshot data already exists at: $TARGET_PROJECT_ROOT${NC}"
  else
    # Download and extract snapshot
    echo -e "${ORANGE}${BOLD}Downloading snapshot...${NORMAL}"
    local snapshot_url snapshot_file
    snapshot_url=$("${parsed_dir}/scripts/download_snapshot.sh" --get-url-only)
    if [[ $? -ne 0 ]]; then
      log "${RED}Failed to determine snapshot URL${NC}"
      exit 1
    fi
    snapshot_file="${TARGET_PROJECT_ROOT}/$(basename "$snapshot_url")"
    if ! "${parsed_dir}/scripts/download_snapshot.sh"; then
      log "${RED}Snapshot download failed${NC}"
      exit 1
    fi
    echo -e "${GREEN}${BOLD}Snapshot Downloaded!${NORMAL}"

    echo -e "${ORANGE}${BOLD}Extracting snapshot to:${NC} $TARGET_PROJECT_ROOT"
    if [[ "$snapshot_file" =~ \.tar\.lz4$ ]]; then
      if ! command -v lz4 &> /dev/null; then
        echo "lz4 not found. Please install it (e.g., 'sudo apt install lz4')."
        exit 1
      fi
      tar -I lz4 -xvf "$snapshot_file" -C "$TARGET_PROJECT_ROOT" || {
        log "${RED}Failed to extract snapshot${NC}"
        exit 1
      }
    else
      log "${RED}Unsupported snapshot format: $snapshot_file${NC}"
      exit 1
    fi
    echo -e "${GREEN}Snapshot restored successfully to: $TARGET_PROJECT_ROOT${NC}"
  fi
elif [[ "$SYNC_FROM" == "chain" ]]; then
  echo -e "${ORANGE}${BOLD}Sync mode:${NC} ${RED}chain${NC}"
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