{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.idea {
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.webstorm
    jdk21
    maven
    gradle
  ];
}
