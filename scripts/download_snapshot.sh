#!/bin/bash
set -e

# Detect base path
source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

# Load environment variables
source "${parsed_dir}/scripts/lib/load_variables.sh"

# Define default values if not set
: ${NETWORK:=mainnet}
: ${SNAPSHOT_TYPE:=archive}  # Options: archive, full
: ${TARget_project_root:=/$BASE_DIR/$NODE_CLIENT/data}

# Build snapshot URL
SNAPSHOT_URL="https://snapshots.merkle.io/$NETWORK/$SNAPSHOT_TYPE/reth-latest.tar.zst"

# Create target dir
mkdir -p "$TARget_project_root"

echo "Downloading merkle snapshot from:"
echo "$SNAPSHOT_URL"

curl -L "$SNAPSHOT_URL" -o reth-latest.tar.zst

echo "Extracting snapshot to $TARget_project_root..."
if ! command -v unzstd &> /dev/null; then
  echo "unzstd could not be found. Please install zstd."
  exit 1
fi
tar --use-compress-program=unzstd -xf reth-latest.tar.zst -C "$TARget_project_root"

rm reth-latest.tar.zst
echo "Snapshot restored successfully to: $TARget_project_root"
