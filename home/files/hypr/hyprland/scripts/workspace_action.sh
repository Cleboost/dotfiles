#!/usr/bin/env bash
curr_workspace="$(hyprctl activeworkspace -j | jq -r ".id")"
dispatcher="$1"
shift ## The target is now in $1, not $2

if [[ -z "${dispatcher}" || "${dispatcher}" == "--help" || "${dispatcher}" == "-h" || -z "$1" ]]; then
  echo "Usage: $0 <dispatcher> <target>"
  exit 1
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
  target_workspace=$((((curr_workspace - 1) / 10 ) * 10 + $1))
else
  target_workspace="$1"
fi

if [[ "${dispatcher}" == "workspace" ]]; then
  hyprctl dispatch "hl.dsp.focus({ workspace = \"${target_workspace}\" })"
elif [[ "${dispatcher}" == "movetoworkspacesilent" ]]; then
  hyprctl dispatch "hl.dsp.window.move({ workspace = \"${target_workspace}\", follow = false })"
else
  hyprctl dispatch "${dispatcher}" "${target_workspace}"
fi
