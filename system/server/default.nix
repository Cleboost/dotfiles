# NixOS commun serveur (VPS prod) — pas de desktop, pas de Hyprland.
{ pkgs, ... }:

{
  imports = [
    ../options.nix
    ./boot.nix
    ./network.nix
    ./packages.nix
    ./user.nix
    ../services/docker.nix
    ./services/openssh.nix
  ];

  nix.settings = {
    trusted-users = [ "root" "cleboost" ];
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    auto-optimise-store = true;
  };

  nix.optimise.automatic = true;

  programs.nh = {
    enable = true;
    flake = "/home/cleboost/dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep 10";
      dates = "weekly";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  services.earlyoom = {
    enable = true;
    enableNotifications = false;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=200M
    MaxRetentionSec=1month
  '';

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

  programs.nix-ld.enable = true;
  system.stateVersion = "26.05";
}
