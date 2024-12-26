#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

main() {
  local args=(
    --option sandbox true
    --show-trace
    --print-build-logs
  )

  rm -f ./result

  nix build .#triton-llvm --out-link ./result "${args[@]}"

  # exec ./result-naja/bin/naja_edit -h
}
main "$@"
