{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.gaming.prismlauncher {
  home.packages = [ pkgs.prismlauncher ];
}
