#!/usr/bin/env bash
# Switch an ALREADY INSTALLED NixOS machine to the portable demo host.
# Never partitions or formats drives. No changes without --apply.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET="$REPO_DIR/hosts/cleboost-demo/hardware-configuration.nix"

if [[ "${1:-}" != "--apply" || $# -ne 1 ]]; then
  cat <<'USAGE'
Install the full cleboost-demo NixOS configuration on an existing NixOS system.

  bash system/scripts/install-demo.sh --apply

This CHANGES the current OS configuration. It does not partition disks.
For a guest PC, use the live ISO instead (see README).
USAGE
  exit 0
fi

if [[ ! -f /etc/NIXOS ]]; then
  echo "This installer runs only on an already installed NixOS system." >&2
  exit 1
fi

if [[ "$(findmnt -n -o FSTYPE /)" == "tmpfs" ]]; then
  echo "You are on a live system. This script is for persistent installations." >&2
  exit 1
fi

current_host="$(hostname)"
case "$current_host" in
  cleboost-sage|cleboost-brain)
    echo "Refusing to replace the configuration of personal host $current_host." >&2
    exit 1
    ;;
esac

if ! command -v nixos-generate-config >/dev/null 2>&1; then
  echo "nixos-generate-config is missing." >&2
  exit 1
fi

echo "Generating disk and kernel configuration for this machine..."
temp_hw="$(mktemp)"
trap 'rm -f "$temp_hw"' EXIT
sudo nixos-generate-config --show-hardware-config > "$temp_hw"

if ! grep -q 'fileSystems."/"' "$temp_hw"; then
  echo "Hardware detection did not find a root filesystem; aborting." >&2
  exit 1
fi

cp "$temp_hw" "$TARGET"

# Git flakes include tracked files. Stage only the detected hardware file.
# This is machine-specific; do not commit it back to the public repo.
git -C "$REPO_DIR" add -- hosts/cleboost-demo/hardware-configuration.nix

echo "Building the demo system first..."
sudo nixos-rebuild build --flake "$REPO_DIR#cleboost-demo"

echo "Switching this machine to cleboost-demo..."
sudo nixos-rebuild switch --flake "$REPO_DIR#cleboost-demo"

echo "Set the demo user's local password to enable login after reboot."
sudo passwd cleboost

echo "Done. Reboot to start the Cleboost demo session."
