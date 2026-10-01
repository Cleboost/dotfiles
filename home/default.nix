{ config, pkgs, hostName, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  imports = [
    (import (./hosts + "/${hostName}.nix"))
    ./modules/theme.nix
    ./modules/shell.nix
    ./modules/hyprland.nix
    ./modules/umbriel.nix
    ./modules/apps.nix
    ./modules/packages.nix
    ./modules/secrets.nix
  ];

  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # User custom scripts into ~/.local/bin
  home.file.".local/bin" = {
    source = ./files/bin;
    recursive = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
