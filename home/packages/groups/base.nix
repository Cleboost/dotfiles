# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/base.nix — CLI + Wayland session utilities (every host)
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "base" config.cleboost.groups) {
  home.packages = with pkgs; [
    gh
    nvd
    nixpkgs-review
    nix-output-monitor
    ripgrep
    fd
    jq
    fastfetch
    socat
    netcat-openbsd
    age
    p7zip
    unzip
    rsync

    brightnessctl
    playerctl
    wl-clipboard
    hyprpicker
    wlsunset
    libnotify

    rquickshare
    bitwarden-desktop
    spotifast
    discord

    google-chrome
    nautilus
  ];
}
