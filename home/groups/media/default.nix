{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "media" config.cleboost.groups) {
  home.packages = with pkgs; [
    qbittorrent
    mpv
    feh
    evince
    lollypop
  ];

  xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source =
    ./qbittorrent/catppuccin-mocha.qbtheme;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.gnome.Evince.desktop";
    "audio/mpeg" = "org.gnome.Lollypop.desktop";
    "audio/x-mpeg" = "org.gnome.Lollypop.desktop";
    "audio/mp3" = "org.gnome.Lollypop.desktop";
    "audio/x-mp3" = "org.gnome.Lollypop.desktop";
    "audio/ogg" = "org.gnome.Lollypop.desktop";
    "audio/flac" = "org.gnome.Lollypop.desktop";
    "audio/wav" = "org.gnome.Lollypop.desktop";
    "audio/x-vorbis+ogg" = "org.gnome.Lollypop.desktop";
    "audio/opus" = "org.gnome.Lollypop.desktop";
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "image/png" = "feh.desktop";
    "image/jpeg" = "feh.desktop";
    "image/webp" = "feh.desktop";
  };
}
