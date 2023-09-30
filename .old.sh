#!/usr/bin/env bash

main() {
  local cache="$_CACHE_DIR"

  printf '| %-25s | %-12s | %-12s | %-8s | %-8s | %-8s | %-8s | %-8s |\n' \
    'Symbol' 'Date' 'Price' '1M' '6M' '1Y' 'YTD' 'ALL'
  printf '| %-25s | %-12s | %-12s | %-8s | %-8s | %-8s | %-8s | %-8s |\n' \
    '---' '---' '---' '---' '---' '---' '---' '---'

  local symbol nav_json
  for symbol in "$@"; do
    start "$symbol"

    nav_json="$cache/$symbol-nav.json"
    fetch_nav "$symbol" "$nav_json"
    perf_json="$cache/$symbol-perf.json"
    fetch_perf "$symbol" "$nav_json" "$perf_json"

    print "$cache" "$symbol" \
      "$nav_json" "$perf_json"
  done
  return 0
}

fetch_nav() {
  local symbol="${1// /%2520}" output="$2"
  ## https://portal.settrade.com/settrade/fund-info
  __curl "https://api.settrade.com/api/mutual-fund/$symbol/nav" "$output"
}

fetch_perf() {
  local symbol="${1// /%2520}" input="$2" output="$3"

  local date
  date="$(__jq ".date" "$input")"
  date="$(__date_format "$date")"
  __curl "https://api.settrade.com/api/mutual-fund/$symbol/performance?date=$date" "$output"
}

start() {
  local symbol="$1"
  printf '| %-25s ' "$symbol"
}

print() {
  local cache="$1" symbol="$2" nav_json="$3" perf_json="$4"

  local price date
  price="$(__jq ".navPerUnit" "$nav_json")"
  date="$(__jq ".date" "$nav_json")"

  local ytd m1 m6 y1 all
  ytd="$(__jq '.performances[] | select(.period == "YTD") | .percentChange // 999' "$perf_json")"
  m1="$(__jq '.performances[] | select(.period == "1M") | .percentChange // 999' "$perf_json")"
  m6="$(__jq '.performances[] | select(.period == "6M") | .percentChange // 999' "$perf_json")"
  y1="$(__jq '.performances[] | select(.period == "1Y") | .percentChange // 999' "$perf_json")"
  all="$(__jq '.performances[] | select(.period == "FIRSTTRADE") | .percentChange // 999' "$perf_json")"

  printf '| %-12s | %-12s | %-8s | %-8s | %-8s | %-8s | %-8s |\n' \
    "$(__date_format "$date")" "$price" \
    "$(printf '%.2f' "$m1")" \
    "$(printf '%.2f' "$m6")" \
    "$(printf '%.2f' "$y1")" \
    "$(printf '%.2f' "$ytd")" \
    "$(printf '%.2f' "$all")"
}

__date_format() {
  date -jf "%Y-%m-%dT%H:%M:%S+07:00" "$1" +%d/%m/%Y
}

__jq() {
  jq --compact-output \
    --monochrome-output \
    --raw-output \
    "$@"
}

## Add $NO_CACHE=1 to force download even cache exist
__curl() {
  local url="$1" output="$2"
  if test -f "$output" && test -z "$NO_CACHE"; then
    ## Use cached instead
    return 0
  fi

  curl --silent --show-error \
    --location \
    --output "$output" \
    "$url"
}

__index() {
  local script="$1"
  shift

  local cache_base="${TMPDIR:-/tmp}" curr_ts
  curr_ts="$(date +"%s")"

  export _CACHE_DIR="${CACHE_DIR:-$cache_base/.finnomena.caches.v0}"
  export _CACHE_CREATED="${CACHE_CREATED:-$_CACHE_DIR/.created.time}"

  local prev_ts diff_ts
  if test -f "$_CACHE_CREATED"; then
    prev_ts="$(cat "$_CACHE_CREATED")"
    diff_ts="$((curr_ts - prev_ts))"
    ## 1 hour
    if [ $diff_ts -gt 3600 ]; then
      rm -r "$_CACHE_DIR" &&
        echo "Clean old cache directory"
    fi
  fi

  if ! test -d "$_CACHE_DIR"; then
    mkdir -p "$_CACHE_DIR" &&
      printf "%s" "$curr_ts" >"$_CACHE_CREATED" &&
      echo "Create new cache directory at $_CACHE_DIR"
  fi
  if ! test -f "$_CACHE_CREATED"; then
    printf "%s" "$curr_ts" >"$_CACHE_CREATED" &&
      echo "Create cache timestamp"
  fi

  "$script" "$@"

  unset _CACHE_DIR _CACHE_CREATED
}

__index main \
  "K-CHANGE-SSF" \
  "K-USA-SSF" \
  "KFGTECH-A" \
  "KFGBRANSSF" \
  "KFS100SSF" \
  "KKP ACT FIXED-SSF" \
  "KKP INCOME-H-SSF" \
  "KKP PGE-H-SSF" \
  "ONE-UGG-ASSF" \
  "PRINCIPAL iPROPEN-SSF" \
  "SCBGOLDH-SSF" \
  "SCBNEXT(SSF)" \
  "SCBVIET(SSFA)" \
  "UGIS-SSF"
