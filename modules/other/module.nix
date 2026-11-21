{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.other {
  home.packages = with pkgs; [
    blockbench
    blender
  ];
}
