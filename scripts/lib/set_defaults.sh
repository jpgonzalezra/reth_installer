#!/bin/bash

# Default values for required vars
: "${SYNC_FROM:=chain}"
: "${NETWORK:=mainnet}"
: "${SNAPSHOT_TYPE:=archive}"
: "${RETH_FLAGS:=debug,eth,net,trace,txpool,web3,rpc}"

# Validate SYNC_FROM
if [[ "$SYNC_FROM" != "merkle" && "$SYNC_FROM" != "chain" ]]; then
    SYNC_FROM="chain"
    echo "⚠️ Invalid SYNC_FROM value. Defaulting to: chain"
fi