{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.scrcpy {
  home.packages = with pkgs; [
    scrcpy
    android-tools
  ];
}
