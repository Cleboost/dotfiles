#!/usr/bin/env bash
# Installe / met à jour cleboost-usb sur un NixOS déjà présent sur une clé USB.
# Refuse les disques non amovibles et les hosts perso sage/brain.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET="$REPO_DIR/hosts/cleboost-usb/hardware-configuration.nix"

root_is_removable() {
  local root_src disk
  root_src="$(findmnt -n -o SOURCE /)"
  disk="$(lsblk -no PKNAME "$root_src" 2>/dev/null || true)"
  if [[ -z "$disk" ]]; then
    disk="${root_src#/dev/}"
    disk="${disk%%[0-9]*}"
  fi
  [[ -n "$disk" && -r "/sys/block/$disk/removable" ]] || return 1
  [[ "$(cat "/sys/block/$disk/removable")" == "1" ]]
}

if [[ "${1:-}" != "--apply" || $# -ne 1 ]]; then
  cat <<'USAGE'
Install cleboost-usb on a NixOS system that lives on a removable USB drive.

  bash system/scripts/install-usb.sh --apply

Prerequisites:
  - Partition and mount the USB (ESP + root), nixos-install or existing NixOS on the stick
  - Run this script from that installation (root filesystem on removable media)

This updates hardware-configuration.nix from the current machine and switches the config.
It does not partition disks.
USAGE
  exit 0
fi

if [[ ! -f /etc/NIXOS ]]; then
  echo "This installer runs only on an already installed NixOS system." >&2
  exit 1
fi

if [[ "$(findmnt -n -o FSTYPE /)" == "tmpfs" ]]; then
  echo "You are on a live system. Install NixOS on the USB first, then re-run." >&2
  exit 1
fi

if ! root_is_removable; then
  echo "Refusing: root filesystem is not on removable media (expected USB stick)." >&2
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

echo "Generating disk and kernel configuration for this USB system..."
temp_hw="$(mktemp)"
trap 'rm -f "$temp_hw"' EXIT
sudo nixos-generate-config --show-hardware-config > "$temp_hw"

if ! grep -q 'fileSystems."/"' "$temp_hw"; then
  echo "Hardware detection did not find a root filesystem; aborting." >&2
  exit 1
fi

cp "$temp_hw" "$TARGET"

git -C "$REPO_DIR" add -- hosts/cleboost-usb/hardware-configuration.nix

echo "Building cleboost-usb..."
sudo nixos-rebuild build --flake "$REPO_DIR#cleboost-usb"

echo "Switching to cleboost-usb..."
sudo nixos-rebuild switch --flake "$REPO_DIR#cleboost-usb"

echo "Set the user password if needed: sudo passwd cleboost"
echo "Done. Boot from USB on guest PCs (UEFI USB boot, Secure Boot may need disabling)."
