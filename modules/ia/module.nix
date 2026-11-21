{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.ia {
  home.packages = with pkgs; [
    code-cursor
    cursor-cli
    inputs.claude-desktop.packages.${stdenv.hostPlatform.system}.default
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default
    (callPackage ../../pkgs/rakazo.nix { })
  ];
}
