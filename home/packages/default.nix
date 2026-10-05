# ──────────────────────────────────────────────────────────────────────────────
# home/packages/default.nix — user packages on every host
# Host-only packages: hosts/<hostname>/home.nix
# ──────────────────────────────────────────────────────────────────────────────
{
  imports = [
    ./gui.nix
    ./dev.nix
    ./cli.nix
    ./wayland.nix
  ];
}
