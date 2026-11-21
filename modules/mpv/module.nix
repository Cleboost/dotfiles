{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.mpv {
  home.packages = [ pkgs.mpv ];

  xdg.mimeApps.defaultApplications = {
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
  };
}
