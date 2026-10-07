# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/base-apps.nix — CLI toolbox & everyday desktop apps
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "base-apps" config.cleboost.groups) {
  home.packages = with pkgs; [
    # ── CLI ───────────────────────────────────────────────────────────────────
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

    # ── Desktop apps ────────────────────────────────────────────────────────────
    rquickshare
    bitwarden-desktop
    spotifast
    discord
    google-chrome
    nautilus
  ];
}
