#!/bin/bash

# Snapshot config
: "${SYNC_FROM:=chain}"
: "${SNAPSHOT_TYPE:=archive}"
: "${SNAPSHOT_PATH:=}"

# Ethereum config
: "${NETWORK:=mainnet}"
: "${RETH_FLAGS:=debug,eth,net,trace,txpool,web3,rpc}"

# Paths
: "${TARGET_PROJECT_ROOT:=/$BASE_DIR/$NODE_CLIENT/data}"

# Validate SYNC_FROM
if [[ "$SYNC_FROM" != "merkle" && "$SYNC_FROM" != "chain" ]]; then
    SYNC_FROM="chain"
    echo "Invalid SYNC_FROM value. Defaulting to: chain"
fi
