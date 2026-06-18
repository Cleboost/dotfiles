#!/bin/bash
# Initialize starship.toml from chezmoi repository if it does not exist in destination

CONFIG_FILE="$HOME/.config/starship.toml"
SOURCE_FILE="$HOME/.local/share/chezmoi/dot_config/starship.toml"

if [ ! -f "$CONFIG_FILE" ] || ! grep -q "success_symbol" "$CONFIG_FILE"; then
  echo "=================================================="
  echo "Restoring base starship.toml from dotfiles..."
  echo "=================================================="
  mkdir -p "$HOME/.config"
  cp "$SOURCE_FILE" "$CONFIG_FILE"
fi
