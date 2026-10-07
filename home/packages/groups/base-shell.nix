# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/base-shell.nix — Wayland session & desktop layer helpers
# Hyprland / Noctalia configs live under home/hyprland, home/apps/noctalia, nixos/
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "base-shell" config.cleboost.groups) {
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    wl-clipboard
    hyprpicker
    wlsunset
    libnotify
  ];
}
