# ──────────────────────────────────────────────────────────────────────────────
# home/packages/default.nix — package groups (enabled via cleboost.groups)
# ──────────────────────────────────────────────────────────────────────────────
{
  imports = [
    ./groups/base.nix
    ./groups/dev.nix
    ./groups/gui.nix
    ./groups/social.nix
    ./groups/media.nix
    ./groups/other.nix
    ./groups/gaming.nix
  ];
}
