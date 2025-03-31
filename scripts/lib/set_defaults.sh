#!/bin/bash

# Snapshot config
: "${SYNC_FROM:=chain}"
: "${SNAPSHOT_TYPE:=archive}"

# Ethereum config
: "${NETWORK:=mainnet}"
: "${RETH_FLAGS:=debug,eth,net,trace,txpool,web3,rpc}"

# Paths
: "${TARGET_PROJECT_ROOT:=/$BASE_DIR/$NODE_CLIENT/data}"

# Validations
if [[ ! "$NETWORK" =~ ^(mainnet|sepolia|holesky)$ ]]; then
  echo "Invalid NETWORK value '$NETWORK'. Defaulting to 'mainnet'"
  NETWORK="mainnet"
fi

if [[ "$SYNC_FROM" != "merkle" && "$SYNC_FROM" != "chain" ]]; then
    SYNC_FROM="chain"
    echo "Invalid SYNC_FROM value. Defaulting to: chain"
fi
