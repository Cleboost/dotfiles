#!/bin/bash
# Initialize starship.toml from chezmoi repository if it does not exist in destination

if [ ! -f "$HOME/.config/starship.toml" ]; then
  echo "=================================================="
  echo "Initializing ~/.config/starship.toml from dotfiles..."
  echo "=================================================="
  mkdir -p "$HOME/.config"
  cp "$HOME/.local/share/chezmoi/dot_config/starship.toml" "$HOME/.config/starship.toml"
fi
