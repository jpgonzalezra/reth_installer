#!/bin/bash
set -e

# Install and enable UFW
sudo apt-get update
sudo apt-get install -y ufw
sudo ufw --force enable

# Allow SSH
sudo ufw allow 22 comment 'SSH'

# Define ports to allow
PORT_RULES=(
  "30303 tcp Ethereum P2P"
  "30303 udp Ethereum P2P"
  "9000 tcp Lighthouse beacon"
  "9000 udp Lighthouse beacon"
  "9001 tcp Lighthouse beacon"
  "9001 udp Lighthouse beacon"
  "9909 tcp Lighthouse beacon"
  "9909 udp Lighthouse beacon"
  "9999 tcp Lighthouse beacon"
  "9999 udp Lighthouse beacon"
  "9090 tcp Lighthouse beacon"
  "9090 udp Lighthouse beacon"
  "9911 tcp Lighthouse beacon"
  "9911 udp Lighthouse beacon"
  "6007 tcp reth logs"
)

# Apply UFW rules for IPv4 and IPv6
for rule in "${PORT_RULES[@]}"; do
  read -r port proto comment <<< "$rule"
  echo "Allowing $port/$proto ($comment)"
  sudo ufw allow "$port/$proto" comment "$comment"
  sudo ufw allow from any to any port "$port" proto "$proto"
done

# Reload UFW and show status
sudo ufw reload
sudo ufw status verbose