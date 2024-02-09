#!/usr/bin/env bash

cache_init() {
  local root="$_FIN_PATH_TMP"
  local created="${_FIN_PATH_TMP_TIMESTAMP:-$root/.created.time}"

  local ts ts_prev ts_diff
  ts="$(date +"%s")"
  if test -f "$created"; then
    ts_prev="$(cat "$created")"
    ts_diff="$((ts - ts_prev))"

    ## 1 days
    [ $ts_diff -gt 86400 ] && rm -r "$root" &&
      logger_info "Clean old cache directory"
  fi

  if ! test -d "$root"; then
    mkdir -p "$root" && printf "%s" "$ts" >"$created" &&
      logger_info "Create new cache directory at %s" "$root"
  fi

  if ! test -f "$created"; then
    printf "%s" "$ts" >"$created" &&
      logger_info "Create cache timestamp"
  fi
}

cache_mkdir() {
  if test -z "$1"; then
    local name="d.XXXXXX"
    mktemp -p "${_FIN_PATH_TMP:?}" -dt "$name"
  else
    local name="${1// /_}"
    mkdir -p "${_FIN_PATH_TMP:?}/$name"
    printf '%s/%s' "${_FIN_PATH_TMP:?}" "$name"
  fi
}

## Generate filename
cache_file() {
  local output
  if test -z "$1"; then
    local name="f.XXXXXX"
    output="$(mktemp -p "${_FIN_PATH_TMP:?}" -t "$name")"
    rm "$output"
  else
    local name="${1// /_}"
    output="${_FIN_PATH_TMP:?}/$name"
  fi

  local directory
  directory="$(dirname "$output")"
  if ! test -d "$directory"; then
    mkdir -p "$directory"
  fi

  printf '%s' "$output"
}

cache_clean() {
  unset _FIN_PATH_TMP
}
