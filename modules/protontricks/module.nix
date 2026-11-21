{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.gaming.protontricks {
  home.packages = [ pkgs.protontricks ];
}
