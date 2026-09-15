{ config, pkgs, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  imports = [
    ./modules/shell.nix
    ./modules/hyprland.nix
    ./modules/umbriel.nix
    ./modules/apps.nix
    ./modules/dev.nix
  ];

  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
