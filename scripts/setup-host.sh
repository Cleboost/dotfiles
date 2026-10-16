#!/usr/bin/env bash
# Setup a fresh NixOS install with cleboost dotfiles
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

HOST="${1:-}"

if [[ -z "$HOST" ]]; then
  echo "Usage: bash scripts/setup-host.sh <hostname>"
  echo "Available hosts in flake:"
  echo "  - cleboost-brain (Desktop)"
  echo "  - cleboost-sage  (Laptop)"
  echo "  - cleboost-demo  (Generic / Demo)"
  exit 1
fi

HOST_DIR="$REPO_DIR/hosts/$HOST"

if [[ ! -d "$HOST_DIR" ]]; then
  echo "Error: Host directory '$HOST_DIR' does not exist." >&2
  exit 1
fi

echo "==> 1. Generating hardware configuration for host '$HOST'..."
sudo nixos-generate-config --show-hardware-config > "$HOST_DIR/hardware-configuration.nix"

echo "==> 2. Staging hardware-configuration.nix for Git/Flake..."
git -C "$REPO_DIR" add "$HOST_DIR/hardware-configuration.nix"

echo "==> 3. Building and switching NixOS configuration to '$HOST'..."
sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST"

echo ""
echo "=========================================================="
echo " Setup complete for '$HOST'!"
echo " You can now reboot to enter your new environment:"
echo "   sudo reboot"
echo "=========================================================="
