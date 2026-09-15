#!/usr/bin/env bash
curr_workspace="$(hyprctl activeworkspace -j | jq -r ".id")"
dispatcher="$1"
shift ## The target is now in $1, not $2

if [[ -z "${dispatcher}" || "${dispatcher}" == "--help" || "${dispatcher}" == "-h" || -z "$1" ]]; then
  echo "Usage: $0 <dispatcher> <target>"
  exit 1
fi

dispatch_cmd() {
  local d="$1"
  local target="$2"

  if [[ "$d" == "workspace" ]]; then
    hyprctl dispatch "hl.dsp.focus({ workspace = \"${target}\" })"
  elif [[ "$d" == "movetoworkspace" ]]; then
    hyprctl dispatch "hl.dsp.window.move({ workspace = \"${target}\", follow = true })"
  elif [[ "$d" == "movetoworkspacesilent" ]]; then
    hyprctl dispatch "hl.dsp.window.move({ workspace = \"${target}\", follow = false })"
  else
    hyprctl dispatch "${d}" "${target}"
  fi
}

if [[ "$1" == *"+"* || "$1" == *"-"* ]]; then ## Is this something like r+1 or -1?
  dispatch_cmd "${dispatcher}" "$1"
elif [[ "$1" =~ ^[0-9]+$ ]]; then ## Is this just a number?
  target_workspace=$((((curr_workspace - 1) / 10 ) * 10 + $1))
  dispatch_cmd "${dispatcher}" "${target_workspace}"
else
  dispatch_cmd "${dispatcher}" "$1" ## In case the target is a string, required for special workspaces.
  exit 1
fi
