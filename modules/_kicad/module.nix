{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.kicad {
  home.packages = [ pkgs.kicad ];
}
