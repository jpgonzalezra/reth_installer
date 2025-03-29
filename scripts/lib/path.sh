#!/bin/bash

# Returns the directory where the current script resides
get_script_dir() {
  local src="${BASH_SOURCE[0]}"
  while [ -h "$src" ]; do
    local dir="$(cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)"
    src="$(readlink "$src")"
    [[ $src != /* ]] && src="$dir/$src"
  done
  cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd
}

# Returns the root of the project by trimming /scripts or /scripts/lib if present
get_project_root() {
  local script_dir
  script_dir="$(get_script_dir)"
  if [[ "$script_dir" == */scripts/lib ]]; then
    echo "${script_dir%/scripts/lib}"
  elif [[ "$script_dir" == */scripts ]]; then
    echo "${script_dir%/scripts}"
  else
    echo "$script_dir"
  fi
}