#!/usr/bin/env bash

config_get() {
  # shellcheck disable=SC2206
  local configs=($1) search="$2"

  local data
  for data in "${configs[@]}"; do
    if [[ "$data" =~ ^$search= ]]; then
      printf '%s' "${data#*=}"
      return 0
    fi
  done

  for data in "${_FIN_CONF_DEFAULT[@]}"; do
    if [[ "$data" =~ ^$search= ]]; then
      printf '%s' "${data#*=}"
      return 0
    fi
  done

  return 1
}
