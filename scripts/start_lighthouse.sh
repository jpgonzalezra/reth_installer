#!/bin/bash

source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

source "${parsed_dir}/scripts/lib/load_variables.sh"
source "${parsed_dir}/scripts/lib/get_os_arch.sh"

sudo /$BASE_DIR/lighthouse/lighthouse beacon_node --datadir /$BASE_DIR/lighthouse/data --network $NETWORK --http --execution-endpoint http://localhost:8551 --execution-jwt /$BASE_DIR/$NODE_CLIENT/data/jwt.hex --checkpoint-sync-url https://mainnet-checkpoint-sync.stakely.io --disable-backfill-rate-limiting --genesis-backfill --disable-deposit-contract-sync --execution-timeout-multiplier 10 --historic-state-cache-size 4 --disable-lock-timeouts --listen-address :: --listen-address 0.0.0.0 --port 9909 --port6 9911 --discovery-port6 9999 --target-peers 200 --validator-monitor-auto --metrics
