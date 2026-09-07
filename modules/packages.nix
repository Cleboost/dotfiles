# Module des logiciels et paquets système
{ config, pkgs, inputs, ... }:

{
  # Autoriser les paquets propriétaires (ex: drivers nvidia, cursor, discord, etc.)
  nixpkgs.config.allowUnfree = true;

  # Polices système
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  # Activer le shell Fish au niveau système pour les complétions et vendor functions
  programs.fish.enable = true;

  # Netbird & Services
  services.netbird.enable = true;

  # Paquets installés au niveau du système
  environment.systemPackages = with pkgs; [
    # Applications graphiques & éditeurs
    zed-editor
    code-cursor
    discord
    google-chrome

    # Antigravity CLI & IDE
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-cli
    inputs.antigravity.packages.${pkgs.system}.google-antigravity-ide

    # Terminal & Outils CLI essentiels
    kitty
    git
    nano
    fastfetch
    btop

    # Utilitaires Wayland & Système
    wl-clipboard
    brightnessctl
    playerctl
    pciutils
    usbutils
    jq
    socat
    netcat-openbsd
    fzf
    eza
    ripgrep
    fd
    rsync
    age
  ];
}
