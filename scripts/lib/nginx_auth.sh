#!/bin/bash

source "${BASH_SOURCE%/*}/path.sh"
parsed_dir=$(get_parsed_dir)

# Default user if not set
: "${NGINX_USER:=user}"

nginx_auth_file="${parsed_dir}/nginx_auth.txt"

if [[ -n "$NGINX_PASS" ]]; then
  echo "NGINX_PASS already set."
elif [[ -f "$nginx_auth_file" ]]; then
  echo "Loading existing nginx credentials from ${nginx_auth_file}"
  NGINX_USER=$(awk -F':' '{print $1}' "$nginx_auth_file")
  NGINX_PASS=$(awk -F':' '{print $2}' "$nginx_auth_file")
else
  NGINX_PASS=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 12)
  echo -e "$NGINX_USER:$NGINX_PASS" > "$nginx_auth_file"
  echo "Generated new NGINX credentials. Saved to $nginx_auth_file"
fi