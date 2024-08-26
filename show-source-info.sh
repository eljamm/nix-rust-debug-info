#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

main() {
  local args=(
    --option sandbox false
    --show-trace
    --print-build-logs
  )

  rm -f ./result-naja

  nix build .#naja --out-link ./result-naja "${args[@]}"

  exec ./result-naja/bin/naja_edit -h
}
main "$@"
