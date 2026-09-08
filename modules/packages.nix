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

  # Paquets d'administration et utilitaires système de base
  environment.systemPackages = with pkgs; [
    git
    nano
    pciutils
    usbutils
    brightnessctl
    playerctl
    wl-clipboard
  ];
}
