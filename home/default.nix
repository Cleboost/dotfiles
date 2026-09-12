{ config, pkgs, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  imports = [
    ./modules/shell.nix
    ./modules/hyprland.nix
    ./modules/apps.nix
    ./modules/dev.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
