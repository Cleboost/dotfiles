{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.media.lollypop {
  home.packages = [ pkgs.lollypop ];

  xdg.mimeApps.defaultApplications = {
    "audio/mpeg" = "org.gnome.Lollypop.desktop";
    "audio/x-mpeg" = "org.gnome.Lollypop.desktop";
    "audio/mp3" = "org.gnome.Lollypop.desktop";
    "audio/x-mp3" = "org.gnome.Lollypop.desktop";
    "audio/ogg" = "org.gnome.Lollypop.desktop";
    "audio/flac" = "org.gnome.Lollypop.desktop";
    "audio/wav" = "org.gnome.Lollypop.desktop";
    "audio/x-vorbis+ogg" = "org.gnome.Lollypop.desktop";
    "audio/opus" = "org.gnome.Lollypop.desktop";
  };
}
