{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.terminal.fastfetch {
  home.packages = [ pkgs.fastfetch ];

  home.file.".local/bin/fastfetch-random" = {
    source = ./scripts/fastfetch-random;
    executable = true;
  };
  home.file.".local/bin/fastfetch-update-cache" = {
    source = ./scripts/fastfetch-update-cache;
    executable = true;
  };

  xdg.configFile."fastfetch/config.jsonc".source = ./assets/config.jsonc;
  xdg.dataFile."fastfetch/images".source = ./assets/images;
}
