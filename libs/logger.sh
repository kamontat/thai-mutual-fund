#!/usr/bin/env bash

logger_init() {
  return 0
}

logger_error() {
  local format="$1"
  shift

  # shellcheck disable=SC2059
  printf "[ERR] $format\n" "$@" >&2
  exit 1
}

logger_warn() {
  local format="$1"
  shift

  # shellcheck disable=SC2059
  printf "[WRN] $format\n" "$@" >&2
}

logger_info() {
  local format="$1"
  shift

  # shellcheck disable=SC2059
  printf "[INF] $format\n" "$@"
}

logger_clean() {
  return 0
}
