{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.media.obsidian {
  home.packages = with pkgs; [
    obsidian
  ];
}
