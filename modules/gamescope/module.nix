{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.gaming.gamescope {
  home.packages = [ pkgs.gamescope ];
}
