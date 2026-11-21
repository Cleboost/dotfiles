{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.dev {
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.webstorm
    jdk21
    maven
    gradle
    bun
    nixd
    nix-update
    nodejs_22
    rustup
    gcc
    gnumake
    just
    godot_4
    kicad
  ];
}
