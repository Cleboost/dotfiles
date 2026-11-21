{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.gaming.beammp {
  home.packages = [ pkgs.beammp-launcher ];
}
