{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.godot {
  home.packages = [ pkgs.godot_4 ];
}
