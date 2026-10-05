#!/usr/bin/env bash
set -euo pipefail

# Hyprland: force a normal tiled spawn (kitty -1 can inherit maximized geometry).
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("[float off; tile on; fullscreenstate 0 0] kitty -1"))' >/dev/null
else
  exec kitty -1
fi
