{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.spotify {
  home.packages = with pkgs; [
    spotify
  ];
}
