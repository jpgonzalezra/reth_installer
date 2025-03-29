#!/bin/bash
set -e

# Load dependencies
source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_parsed_dir)

source "${parsed_dir}/scripts/lib/load_variables.sh"
source "${parsed_dir}/scripts/lib/get_os_arch.sh"

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Get server's public IPv4
public_ip=$(curl -s https://ipinfo.io/ip || echo "127.0.0.1")

# Reload systemd (in case new services were added)
sudo /bin/systemctl daemon-reload

# Setup summary output file
output_file="${parsed_dir}/setup_summary.txt"
exec > >(tee -i "$output_file")

# Function to print section
print_section() {
  echo -e "\n${BOLD}$1${NC}"
  echo "------------------"
}

# Output
echo -e "${GREEN}Node setup completed successfully!${NC}"

print_section "Monitoring URLs"
echo "🔍 Metrics:     http://${public_ip}:6007"
echo "🌐 HTTP RPC:    http://${public_ip}:6008"
echo "📡 WS RPC:      ws://${public_ip}:6009"

print_section "Service Commands"
echo "View status:"
echo "  sudo systemctl status lighthouse.service"
echo "  sudo systemctl status reth.service"

echo -e "\nView logs (live):"
echo "  sudo journalctl -u lighthouse -f"
echo "  sudo journalctl -u reth -f"

echo -e "\n${BLUE}Setup summary saved to:${NC} $output_file"
