#!/bin/bash
# Install hyprland-dynamic-cursors plugin using hyprpm

if command -v hyprpm >/dev/null 2>&1; then
  echo "=================================================="
  echo "       Installing Hyprland dynamic-cursors        "
  echo "=================================================="
  hyprpm update
  hyprpm add https://github.com/VirtCode/hypr-dynamic-cursors || true
  hyprpm enable dynamic-cursors
else
  echo "hyprpm n'est pas installé, installation des plugins Hyprland ignorée"
fi
