{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.cpp {
  home.packages = with pkgs; [
    gcc
    gnumake
    ninja
    just
  ];
}
