# GUI apps — browser, media, gaming, remote desktop.
{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Navigateur & Communication
    google-chrome
    discord
    telegram-desktop

    # Multimédia, Documents & Partage
    nautilus
    lollypop
    mpv
    feh
    evince
    spotifast
    qbittorrent
    rquickshare

    # Productivité, Notes & Bureau à distance
    bitwarden-desktop
    obsidian
    scrcpy
    android-tools
    inputs.nixpkgs-rustdesk-pr.legacyPackages.${stdenv.hostPlatform.system}.rustdesk-flutter-nightly

    # Gaming & 3D
    prismlauncher
    blockbench
    beammp-launcher
  ];
}
