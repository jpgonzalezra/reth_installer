#!/bin/bash
set -e

get_latest_merkle_snapshot_url() {
  local today
  today=$(date +%Y-%m-%d)

  for i in {0..6}; do
    local candidate_date
    candidate_date=$(date -d "$today - $i days" +%Y-%m-%d)
    local dow
    dow=$(date -d "$candidate_date" +%u)  # 1 = Monday, 4 = Thursday

    if [[ "$dow" == "1" || "$dow" == "4" ]]; then
      echo "https://downloads.merkle.io/reth-${candidate_date}.tar.lz4"
      return
    fi
  done

  return 1
}

# Detect base path
source "${BASH_SOURCE%/*}/lib/path.sh"
parsed_dir=$(get_project_root)

# Load environment variables
source "${parsed_dir}/scripts/lib/load_variables.sh"

# Build snapshot URL
SNAPSHOT_URL=$(get_latest_merkle_snapshot_url)
if [[ $? -eq 0 ]]; then
  echo "Latest snapshot: $SNAPSHOT_URL"
else
  echo "Failed to resolve latest Merkle snapshot URL."
fi

# Create target dir
mkdir -p "$TARGET_PROJECT_ROOT"

echo "Downloading merkle snapshot from:"
echo "$SNAPSHOT_URL"

curl -C - --http1.1 --retry 10 --retry-delay 15 -L "$SNAPSHOT_URL" | tar -I lz4 -xvf - -C "$TARGET_PROJECT_ROOT"
