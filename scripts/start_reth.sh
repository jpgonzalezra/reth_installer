#!/bin/bash
set -e

# Load project root and environment
source "${BASH_SOURCE%/*}/lib/path.sh"
parsed_dir=$(get_project_root)

source "${parsed_dir}/scripts/lib/load_variables.sh"
source "${parsed_dir}/scripts/lib/get_os_arch.sh"

# Paths
RETH_EXECUTABLE="/${BASE_DIR}/${NODE_CLIENT}/${NODE_CLIENT}"
DATA_DIR="/${BASE_DIR}/${NODE_CLIENT}/data"
LOG_DIR="/${BASE_DIR}/${NODE_CLIENT}/logs"

# Start reth node
sudo RUST_LOG=info "$RETH_EXECUTABLE" node \
  --datadir="$DATA_DIR" \
  --chain=mainnet \
# --metrics=5005 \
  --port=30303 \
  --http \
  --http.api="$RETH_FLAGS" \
  --ws \
  --log.file.directory="$LOG_DIR" \
  --ipcdisable \
  --rpc.max-response-size=500 \
  --rpc.max-connections=500 \
  --rpc.max-tracing-requests=500
