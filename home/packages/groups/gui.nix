# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/gui.nix — browser, media, productivity (not gaming)
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, inputs, ... }:

lib.mkIf (lib.elem "gui" config.cleboost.groups) {
  home.packages = with pkgs; [
    google-chrome
    discord
    telegram-desktop

    nautilus
    lollypop
    mpv
    feh
    evince
    spotifast
    qbittorrent
    rquickshare

    bitwarden-desktop
    obsidian
    scrcpy
    android-tools
    inputs.nixpkgs-rustdesk-pr.legacyPackages.${stdenv.hostPlatform.system}.rustdesk-flutter-nightly
  ];
};
}
