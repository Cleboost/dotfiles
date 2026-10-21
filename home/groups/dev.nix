{ config, lib, pkgs, ... }:

{
  imports = [
    ../config/zed/module.nix
  ];

  config = lib.mkIf (lib.elem "dev" config.cleboost.groups) {
    home.packages = with pkgs; [
      jetbrains.idea
      jetbrains.rust-rover
      jetbrains.webstorm
      jdk21
      maven
      gradle
      bun
      nix-update
      nodejs_22
      rustup
      gcc
      gnumake
      just
      godot_4
      kicad
    ];
  };
}
