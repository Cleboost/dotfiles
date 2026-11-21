{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.media.feh {
  home.packages = [ pkgs.feh ];

  xdg.mimeApps.defaultApplications = {
    "image/png" = "feh.desktop";
    "image/jpeg" = "feh.desktop";
    "image/webp" = "feh.desktop";
  };
}
