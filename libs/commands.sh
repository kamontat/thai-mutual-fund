#!/usr/bin/env bash

cmd_fetch_nav() {
  local symbol="${1// /%2520}" output="$2" expires="$3"
  ## https://portal.settrade.com/settrade/fund-info
  __curl \
    "https://api.settrade.com/api/mutual-fund/$symbol/nav" \
    "$output" \
    "$expires"
}

cmd_fetch_perf() {
  local symbol="${1// /%2520}" input="$2" output="$3" expires="$4"

  local date
  date="$(__jq ".date" "$input")"
  date="$(cmd_symbol_date "$date")"
  __curl \
    "https://api.settrade.com/api/mutual-fund/$symbol/performance?date=$date" \
    "$output" \
    "$expires"
}

cmd_symbol_date() {
  date -jf "%Y-%m-%dT%H:%M:%S+07:00" "$1" +%d/%m/%Y
}

__jq() {
  if command -v jq >/dev/null; then
    jq --compact-output --monochrome-output --raw-output "$@"
  fi
}

## Add $FIN_CONF_CACHE=false to disable caching
__curl() {
  if command -v curl >/dev/null; then
    local url="$1" output="$2" expires="${3:-0}"
    shift 3

    local ts ts_diff=0 created
    ts="$(date +"%s")"
    created="$output.time"

    if test -f "$created"; then
      ts_prev="$(cat "$created")"
      ts_diff="$((ts - ts_prev))"
    fi

    # logger_info "$output will expires in %d seconds" "$((expires - ts_diff))"
    if [ $ts_diff -gt "$expires" ] || [[ "$FIN_CONF_CACHE" == "false" ]]; then
      rm "$output"
    fi

    ## Download new file
    if ! test -f "$output"; then
      curl --silent --show-error --location "$@" --output "$output" "$url"
      printf '%s' "$ts" >"$created"
    fi
  fi
}
