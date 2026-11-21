{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.telegram {
  home.packages = with pkgs; [
    telegram-desktop
  ];
}
