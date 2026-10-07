# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/gaming.nix — launchers & helpers (Steam/GameMode: nixos/gaming.nix)
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "gaming" config.cleboost.groups) {
  home.packages = with pkgs; [
    prismlauncher
    beammp-launcher

    mangohud
    gamescope
    protontricks
    vkbasalt
  ];
}
