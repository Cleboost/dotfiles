{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.cursor {
  home.packages = with pkgs; [
    code-cursor
    cursor-cli
  ];
}
