#!/bin/bash

create_nginx_proxy() {
  local name=$1
  local port=$2
  local target=$3
  local extra_config=$4

  sudo tee "/etc/nginx/sites-available/${name}" > /dev/null <<EOL
server {
    listen ${port};

    location / {
        proxy_pass http://localhost:${target};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        $extra_config

        # Basic Authentication
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL

  sudo ln -sf "/etc/nginx/sites-available/${name}" "/etc/nginx/sites-enabled/${name}"
}
