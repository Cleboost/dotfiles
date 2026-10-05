# ──────────────────────────────────────────────────────────────────────────────
# home/packages/gui.nix — GUI apps (browser, media, gaming, remote desktop)
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Browser & communication
    google-chrome
    discord
    telegram-desktop

    # Media, documents & sharing
    nautilus
    lollypop
    mpv
    feh
    evince
    spotifast
    qbittorrent
    rquickshare

    # Productivity, notes & remote desktop
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
