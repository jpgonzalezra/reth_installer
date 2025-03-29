#!/bin/bash

source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

source "${parsed_dir}/scripts/lib/load_variables.sh"
source "${parsed_dir}/scripts/lib/get_os_arch.sh"

sudo RUST_LOG=info /$BASE_DIR/$NODE_CLIENT/$NODE_CLIENT node --datadir=/$BASE_DIR/$NODE_CLIENT/data --chain=mainnet --metrics=5005 --port=30303 --http --http.api "$RETH_FLAGS" --ws --log.persistent --log.directory=/$BASE_DIR/$NODE_CLIENT/logs/ --ipcdisable --rpc-max-response-size 500 --rpc-max-connections 500 --rpc-max-tracing-requests 500