#!/bin/bash

source "${BASH_SOURCE%/*}/lib/path.sh"
parsed_dir=$(get_project_root)

source "${parsed_dir}/scripts/lib/load_variables.sh"
source "${parsed_dir}/scripts/lib/get_os_arch.sh"
source "${parsed_dir}/scripts/lib/systemd.sh"

# Create reth systemd service
create_systemd_service "reth" "reth Service" "$parsed_dir/scripts/start_reth.sh" "reth"

# Create lighthouse systemd service
create_systemd_service "lighthouse" "Lighthouse Service" "$parsed_dir/scripts/start_lighthouse.sh" "lighthouse"

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable and start the reth service
sudo systemctl enable reth.service
sudo systemctl start reth.service

# Enable and start the lighthouse services
sudo systemctl enable lighthouse.service
sudo systemctl start lighthouse.service

