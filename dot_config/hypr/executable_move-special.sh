#!/usr/bin/env bash
set -euo pipefail

move() {
  local cls="$1"
  local target="$2"

  for _ in {1..120}; do
    addr="$(hyprctl -j clients | jq -r --arg cls "$cls" '
      .[] | select(.class==$cls or .initialClass==$cls) | .address
    ' | head -n1)"

    if [[ -n "${addr:-}" && "$addr" != "null" ]]; then
      hyprctl dispatch movetoworkspacesilent "special:${target},address:${addr}"
      return 0
    fi
    sleep 0.25
  done
  return 1
}

move discord comm &
move spotify music &
wait
