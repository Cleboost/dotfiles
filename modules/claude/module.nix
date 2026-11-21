{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.claude {
  home.packages = with pkgs; [
    inputs.claude-desktop.packages.${stdenv.hostPlatform.system}.default
  ];
}
