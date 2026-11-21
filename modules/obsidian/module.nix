{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.obsidian {
  home.packages = with pkgs; [
    obsidian
  ];
}
