#!/usr/bin/env bash

# set -x

__header() {
  echo
  printf '| %-25s | %-12s | %12s | %8s | %8s | %8s | %8s | %8s |\n' \
    'Symbol' 'Date' 'Price' '1M' '6M' '1Y' 'YTD' 'ALL'
  printf '| %-25s | %-12s | %12s | %8s | %8s | %8s | %8s | %8s |\n' \
    '---' '---' '---' '---' '---' '---' '---' '---'
}

__symbol() {
  local raw symbol
  local config expires
  local nav_json
  for raw in "${_FIN_CONF_FUNDS[@]}"; do
    symbol="${raw%%;*}"
    config="${raw#*; }"
    [[ "$symbol" == "$config" ]] && config=""

    expires="$(config_get "$config" "expires")"

    nav_json="$(cache_file "symbols/nav.$symbol.json")"
    cmd_fetch_nav "$symbol" "$nav_json" "$expires"

    perf_json="$(cache_file "symbols/perf.$symbol.json")"
    cmd_fetch_perf "$symbol" "$nav_json" "$perf_json" "$expires"

    __print_result "$symbol" "$nav_json" "$perf_json"
  done
}

__print_result() {
  local symbol="$1" nav_json="$2" perf_json="$3"

  local price date
  price="$(__jq ".navPerUnit" "$nav_json")"
  date="$(__jq ".date" "$nav_json")"

  local ytd m1 m6 y1 all
  ytd="$(__jq '.performances[] | select(.period == "YTD") | .percentChange // 999' "$perf_json")"
  m1="$(__jq '.performances[] | select(.period == "1M") | .percentChange // 999' "$perf_json")"
  m6="$(__jq '.performances[] | select(.period == "6M") | .percentChange // 999' "$perf_json")"
  y1="$(__jq '.performances[] | select(.period == "1Y") | .percentChange // 999' "$perf_json")"
  all="$(__jq '.performances[] | select(.period == "FIRSTTRADE") | .percentChange // 999' "$perf_json")"

  printf '| %-25s | %-12s | %12s | %8s | %8s | %8s | %8s | %8s |\n' \
    "$symbol" \
    "$(cmd_symbol_date "$date")" \
    "$(printf '%.4f' "$price")" \
    "$(printf '%.2f' "$m1")" \
    "$(printf '%.2f' "$m6")" \
    "$(printf '%.2f' "$y1")" \
    "$(printf '%.2f' "$ytd")" \
    "$(printf '%.2f' "$all")"
}

__header
__symbol
