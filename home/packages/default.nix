# ──────────────────────────────────────────────────────────────────────────────
# home/packages/default.nix — package groups (enabled via cleboost.groups)
# ──────────────────────────────────────────────────────────────────────────────
{
  imports = [
    ./groups/base.nix
    ./groups/code.nix
    ./groups/dev.nix
    ./groups/gui.nix
    ./groups/gaming.nix
  ];
}
