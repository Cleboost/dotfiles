# Main NixOS system configuration for Cleboost
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/desktop.nix
    ./modules/noctalia.nix
    ./modules/packages.nix
    ./modules/gaming.nix
  ];

  # Nix package manager settings and Flakes configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    auto-optimise-store = true;
  };

  # Nettoyage automatique : ne conserver que les 10 dernières versions du système
  systemd.services.nix-clean-generations = {
    description = "Garder uniquement les 10 dernières générations NixOS et nettoyer le store";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "nix-keep-10-generations" ''
        ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +10
        ${pkgs.nix}/bin/nix-collect-garbage
      ''}";
    };
  };

  systemd.timers.nix-clean-generations = {
    description = "Timer hebdomadaire de nettoyage des générations NixOS (> 10)";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  # Shell aliases for system rebuild and updates
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain";
    update  = "nix flake update --flake /home/cleboost/dotfiles && sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain";
  };

  # EFI systemd-boot & latest Linux kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # V4L2 Loopback virtual camera (for scrcpy / phone webcam)
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=20 card_label="Phone Camera" exclusive_caps=1
  '';

  # Networking
  networking.hostName = "cleboost-brain";
  networking.networkmanager.enable = true;

  # Localization & Timezone
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

  # Primary user account
  users.users.cleboost = {
    isNormalUser = true;
    description = "Cleboost";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" "input" "adbusers" ];
  };

  # NixOS state version
  system.stateVersion = "25.05";
}
