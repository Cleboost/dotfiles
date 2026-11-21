{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.social.telegram {
  home.packages = with pkgs; [
    telegram-desktop
  ];
}
