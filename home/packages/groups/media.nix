# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/media.nix — playback & downloads
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "media" config.cleboost.groups) {
  home.packages = with pkgs; [
    qbittorrent
    mpv
    feh
  ];
}
