#!/bin/bash

create_systemd_service() {
  local name="$1"
  local description="$2"
  local script_path="$3"
  local syslog_identifier="$4"

  sudo bash -c "cat <<EOF > /etc/systemd/system/${name}.service
[Unit]
Description=${description}
After=network.target network-online.target
Wants=network-online.target

[Service]
User=$USER
ExecStart=/bin/bash ${script_path}
Restart=always
RestartSec=30s

StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=${syslog_identifier}

[Install]
WantedBy=multi-user.target
EOF"
}
