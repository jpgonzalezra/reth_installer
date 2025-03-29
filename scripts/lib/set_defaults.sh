#!/bin/bash

# Default values for required vars
: "${NODE_CLIENT:=reth}"
: "${SYNC_FROM:=chain}"
: "${BASE_DIR:=chain}"
: "${RETH_VERSION:=0.1.0-alpha.1}"
: "${LIGHTHOUSE_VERSION:=4.2.0}"
: "${NETWORK:=mainnet}"
: "${SNAPSHOT_TYPE:=archive}"
: "${RETH_FLAGS:=debug,eth,net,trace,txpool,web3,rpc}"

# Validate SYNC_FROM
if [[ "$SYNC_FROM" != "merkle" && "$SYNC_FROM" != "chain" ]]; then
    SYNC_FROM="chain"
    echo "⚠️ Invalid SYNC_FROM value. Defaulting to: chain"
fi