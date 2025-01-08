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

  nix build .#manim --out-link ./result "${args[@]}"
}
main "$@"
