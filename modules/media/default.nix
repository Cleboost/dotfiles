{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm = {
      home.packages = with pkgs; [
        lollypop
        pdfcraft
        feh
        mpv
      ];

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

        "application/pdf" = "ai.storyteller.pdfcraft.desktop";

        "image/png" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        "image/webp" = "feh.desktop";

        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
      };
    };
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
