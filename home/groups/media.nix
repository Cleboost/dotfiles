{ config, lib, pkgs, ... }:

{
  imports = [
    ../config/qbittorrent/module.nix
  ];

  config = lib.mkIf (lib.elem "media" config.cleboost.groups) {
    home.packages = with pkgs; [
      qbittorrent
      mpv
      feh
      (callPackage ../pkgs/pdfcraft.nix { })
      lollypop
    ];

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "ai.storyteller.pdfcraft.desktop";
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
  };
}
