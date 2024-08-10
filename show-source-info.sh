#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

main() {
  local args=(
    --option sandbox false
    --show-trace
    --print-build-logs
  )

  if [[ -d ~/git/nixpkgs ]]; then
    args+=(--override-input nixpkgs ~/git/nixpkgs)
  else
    nix flake update nixpkgs
  fi

  rm -f ./result-debug ./result-release ./result-sysroot-debug ./result-sysroot-release

  if [[ "$(uname -s)" != Darwin ]]; then
    nix build .#sysroot-debug --out-link ./result-sysroot-debug "${args[@]}"
    nix build .#sysroot-release --out-link ./result-sysroot-release "${args[@]}"
  fi

  nix build .#debug --out-link ./result-debug "${args[@]}"
  nix build .#release --option sandbox false --out-link ./result-release "${args[@]}"

  nix shell nixpkgs#rustc nixpkgs#lldb -c \
    rust-lldb result-debug/bin/nix-rust-debug-info \
    --batch \
    -o 'break set --name nix_rust_debug_info::a_function' \
    -o 'process launch' \
    -o 'source info' ||
    true

  find . -maxdepth 1 -name 'result-*' -exec ls -A {}/bin \;
}
main "$@"
