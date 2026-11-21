{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.javascript {
  home.packages = with pkgs; [
    bun
    nodejs_22
  ];
}
