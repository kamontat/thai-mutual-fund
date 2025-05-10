#!/usr/bin/env bash

_FIN_PATH_PREV="$PWD"
_FIN_PATH_TMP="${FIN_PATH_TMP:-${TMPDIR:-/tmp}/.finnomena.caches.v1}"

_FIN_CONF_DEFAULT=(
  ## Expires is number of seconds for caching of fund will expires
  "expires=86400" # 1 day
  "format=table"  # table | csv | qif
)

## FUNDS = "<NAME>; <CONFIGS>" where configs are
##         space separated `<key>=<value>`
##         e.g. expires=3600 example=true
_FIN_CONF_FUNDS=(
  "ES-SETESG-ThaiESG-A"
  "K-CHANGE-SSF"
  "K-USA-SSF; expires=172800" # 2 day
  "KFGTECH-A"
  "KFGBRANSSF"
  "KFS100SSF"
  "KKP ACT FIXED-SSF"
  "KKP GB THAI ESG"
  "KKP INCOME-H-SSF"
  "KKP PGE-H-SSF"
  "KTAG70/30-THAIESG"
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
# shellcheck source=/dev/null
source "$PWD/libs/configs.sh" || exit 1
# shellcheck source=/dev/null
source "$PWD/libs/commands.sh" || exit 1

logger_init
cache_init

_FIN_EXIT_CODE=0
# shellcheck source=/dev/null
source "$PWD/scripts/main.sh"
_FIN_EXIT_CODE="$?"

cache_clean
logger_clean

cd "$_FIN_PATH_PREV" || exit 1
unset _FIN_PATH_PREV _FIN_PATH_TMP
unset _FIN_CONF_DEFAULT _FIN_CONF_FUNDS

exit "$_FIN_EXIT_CODE"
