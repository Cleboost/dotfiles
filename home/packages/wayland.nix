# ──────────────────────────────────────────────────────────────────────────────
# home/packages/wayland.nix — Wayland / Hyprland session utilities
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    wl-clipboard
    hyprpicker
    wlsunset
    libnotify
  ];
}
