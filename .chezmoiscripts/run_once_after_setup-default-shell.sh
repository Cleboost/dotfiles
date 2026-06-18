#!/bin/bash
# Set default shell to fish if it's not already

if command -v fish >/dev/null 2>&1; then
  CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
  FISH_SHELL=$(which fish)
  if [ "$CURRENT_SHELL" != "$FISH_SHELL" ]; then
    echo "=================================================="
    echo "Setting default shell to fish..."
    echo "=================================================="
    sudo chsh -s "$FISH_SHELL" "$USER"
  fi
fi
