# Configuration principale NixOS pour Cleboost
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/desktop.nix
    ./modules/noctalia.nix
    ./modules/packages.nix
  ];

  # Configuration du gestionnaire de paquets Nix et des Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Raccourcis pour rebuild et màj
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/cleboost/dotfiles-nixos#cleboost-brain";
    update  = "nix flake update --flake /home/cleboost/dotfiles-nixos && sudo nixos-rebuild switch --flake /home/cleboost/dotfiles-nixos#cleboost-brain";
  };

  # Démarrage EFI systemd-boot & Noyau le plus récent
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Réseau
  networking.hostName = "cleboost-brain";
  networking.networkmanager.enable = true;

  # Localisation & Fuseau horaire
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Utilisateur principal
  users.users.cleboost = {
    isNormalUser = true;
    description = "Cleboost";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  # Version d'état NixOS
  system.stateVersion = "25.05";
}
