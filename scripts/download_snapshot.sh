#!/bin/bash
set -e

# Detect base path
source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_parsed_dir)

# Load environment variables
source "${parsed_dir}/scripts/lib/load_variables.sh"

# Define default values if not set
: ${NETWORK:=mainnet}
: ${SNAPSHOT_TYPE:=archive}  # Options: archive, full
: ${TARGET_DIR:=/$BASE_DIR/$NODE_CLIENT/data}

# Build snapshot URL
SNAPSHOT_URL="https://snapshots.merkle.io/$NETWORK/$SNAPSHOT_TYPE/reth-latest.tar.zst"

# Create target dir
mkdir -p "$TARGET_DIR"

echo "Downloading merkle snapshot from:"
echo "$SNAPSHOT_URL"

curl -L "$SNAPSHOT_URL" -o reth-latest.tar.zst

echo "Extracting snapshot to $TARGET_DIR..."
if ! command -v unzstd &> /dev/null; then
  echo "unzstd could not be found. Please install zstd."
  exit 1
fi
tar --use-compress-program=unzstd -xf reth-latest.tar.zst -C "$TARGET_DIR"

rm reth-latest.tar.zst
echo "Snapshot restored successfully to: $TARGET_DIR"
