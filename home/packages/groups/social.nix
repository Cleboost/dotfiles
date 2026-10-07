# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/social.nix — chat & messaging
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "social" config.cleboost.groups) {
  home.packages = with pkgs; [
    discord
    telegram-desktop
    zapfast
  ];
}
