#!/bin/bash
set -e

source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

# Ensure script is run as root
if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# 1) Update the system
sudo apt-get update

# 2) Upgrade the system
sudo apt-get upgrade -y
sudo apt-get install unzip screen -y

# 3) Make another script executable
for script in "${parsed_dir}/scripts/"*.sh; do
    chmod +x "$script"
done
chmod +x "setup_node.sh"

# 4) Load the environment variables
source "${parsed_dir}/scripts/lib/load_variables.sh"
if [[ -z "$BASE_DIR" || -z "$NODE_CLIENT" || -z "$RETH_VERSION" || -z "$LIGHTHOUSE_VERSION" ]]; then
    echo "Missing one or more required environment variables."
    exit 1
fi

# 5) Source the script that returns OS and CPU architecture variables
source "${parsed_dir}/scripts/lib/get_os_arch.sh"

# 6) Check for compatible CPU Architecture
if [[ "$ARCH_RAW" != "x86_64" && "$ARCH_RAW" != "aarch64" ]]; then
    echo "This server is not compatible with reth unfortunately. Exiting..."
    exit 1
fi

# 7) Check for compatible OS
if [[ "$OS" != "linux" ]]; then
    echo "This server is not on a compatible OS unfortunately. Exiting..."
    exit 1
fi

# 8) Make the dirs
mkdir -p /"$BASE_DIR"/"$NODE_CLIENT"/data
mkdir -p /"$BASE_DIR"/lighthouse/data

# 9) Grab the right bins for reth
RETH_NAME="reth-v${RETH_VERSION}-${ARCH_RAW}-unknown-linux-gnu.tar.gz"
RETH_URL="https://github.com/paradigmxyz/reth/releases/download/v${RETH_VERSION}/${RETH_NAME}"
echo "Downloading reth from ${RETH_URL}"
curl -LOs ${RETH_URL}
if [[ ! -f "$RETH_NAME" ]]; then
    echo "Failed to download reth binary."
    exit 1
fi
tar -xzf ${RETH_NAME} -C /$BASE_DIR/$NODE_CLIENT/
rm ${RETH_NAME}

# 10) Grab the right bins for lighthouse
LIGHTHOUSE_NAME="lighthouse-v${LIGHTHOUSE_VERSION}-${ARCH_RAW}-unknown-linux-gnu-portable.tar.gz"
LIGHTHOUSE_URL="https://github.com/sigp/lighthouse/releases/download/v${LIGHTHOUSE_VERSION}/${LIGHTHOUSE_NAME}"
echo "Downloading lighthouse from ${LIGHTHOUSE_URL}"
curl -LOs ${LIGHTHOUSE_URL}
if [[ ! -f "$LIGHTHOUSE_NAME" ]]; then
    echo "Failed to download lighthouse binary."
    exit 1
fi
tar -xzf ${LIGHTHOUSE_NAME} -C /$BASE_DIR/lighthouse/
rm ${LIGHTHOUSE_NAME}

# 11) Reboot the server
echo "Rebooting the server in 5s..."
sleep 5
sudo reboot
