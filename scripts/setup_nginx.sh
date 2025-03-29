#!/bin/bash

source "${BASH_SOURCE%/*}/scripts/lib/path.sh"
parsed_dir=$(get_project_root)

source "${parsed_dir}/scripts/lib/load_variables.sh"
source "${parsed_dir}/scripts/lib/get_os_arch.sh"
source "${parsed_dir}/scripts/lib/nginx_auth.sh"
source "${parsed_dir}/scripts/lib/nginx.sh"

# Install Nginx
sudo apt install nginx -y

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Create password file for basic auth (username is 'user')
echo "$NGINX_USER:$(openssl passwd -apr1 $NGINX_PASS)" | sudo tee /etc/nginx/.htpasswd

# Use helper to generate proxies
create_nginx_proxy "metrics-proxy" 6007 5005 ""
create_nginx_proxy "rpc-http-proxy" 6008 8545 ""
create_nginx_proxy "rpc-ws-proxy" 6009 8546 "proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";"

# Remove default config and reload Nginx
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
