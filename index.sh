#!/usr/bin/env bash

_FIN_PATH_PREV="$PWD"
_FIN_PATH_TMP="${FIN_PATH_TMP:-${TMPDIR:-/tmp}/.finnomena.caches}"

_FIN_CONF_DEFAULT=(
  ## Expires is number of seconds for caching of fund will expires
  "expires=3600"
)

## FUNDS = "<NAME>; <CONFIGS>" where configs are
##         space separated `<key>=<value>`
##         e.g. expires=3600 example=true
_FIN_CONF_FUNDS=(
  "K-CHANGE-SSF; expires=10000"
  "K-USA-SSF"
  "KFGTECH-A"
  "KFGBRANSSF"
  "KFS100SSF"
  "KKP ACT FIXED-SSF"
  "KKP INCOME-H-SSF"
  "KKP PGE-H-SSF"
  "ONE-UGG-ASSF"
  "PRINCIPAL iPROPEN-SSF"
  "SCBGOLDH-SSF"
  "SCBNEXT(SSF)"
  "SCBVIET(SSFA)"
  "UGIS-SSF"
)

cd "$(dirname "$0")" || exit 1

# shellcheck source=/dev/null
source "$PWD/libs/logger.sh" || exit 1
# shellcheck source=/dev/null
source "$PWD/libs/caches.sh" || exit 1

_FIN_EXIT_CODE=0
"$PWD/scripts/main.sh"
_FIN_EXIT_CODE="$?"

cd "$_FIN_PATH_PREV" || exit 1
unset _FIN_PATH_PREV _FIN_PATH_TMP
unset _FIN_CONF_DEFAULT _FIN_CONF_FUNDS

exit "$_FIN_EXIT_CODE"
