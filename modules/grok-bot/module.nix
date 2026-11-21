{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.grok-bot {
  home.packages = with pkgs; [
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default
  ];
}
