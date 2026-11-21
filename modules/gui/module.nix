{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.gui {
  home.packages = with pkgs; [
    scrcpy
    android-tools
  ];
}
