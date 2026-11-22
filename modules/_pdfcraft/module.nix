{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.media.pdfcraft {
  home.packages = [ pkgs.pdfcraft ];

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "ai.storyteller.pdfcraft.desktop";
  };
}
