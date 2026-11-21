{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.rust {
  home.packages = with pkgs; [
    rustup
    just
  ];
}
