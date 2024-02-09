#!/usr/bin/env bash

format_header_table() {
  echo
  printf '| %-25s | %-12s | %12s | %8s | %8s | %8s | %8s | %8s |\n' \
    'Symbol' 'Date' 'Price' '1M' '6M' '1Y' 'YTD' 'ALL'
  printf '| %-25s | %-12s | %12s | %8s | %8s | %8s | %8s | %8s |\n' \
    '---' '---' '---' '---' '---' '---' '---' '---'
}
