#!/bin/bash

get_parsed_dir() {
  local current_directory
  current_directory="$(dirname \"$(readlink -f \"$0\")\")"
  IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
  if [ ${#dir_array[@]} -eq 3 ] && [ "${dir_array[2]}" != "scripts" ]; then
    echo "/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
  else
    echo "/${dir_array[0]}/${dir_array[1]}"
  fi
}