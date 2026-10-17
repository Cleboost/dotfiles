{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "media" config.cleboost.groups) {
  home.packages = with pkgs; [
    qbittorrent
    mpv
    feh
    (callPackage ../../../../pkgs/pdfcraft.nix { })
    lollypop
  ];

  xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source =
    ./qbittorrent/catppuccin-mocha.qbtheme;

  home.activation.qbittorrentTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    conf="${config.xdg.configHome}/qBittorrent/qBittorrent.conf"
    theme="${config.xdg.configHome}/qBittorrent/themes/catppuccin-mocha.qbtheme"
    $DRY_RUN_CMD mkdir -p "$(dirname "$conf")"
    $DRY_RUN_CMD ${pkgs.crudini}/bin/crudini --set "$conf" Preferences 'General\UseCustomUITheme' true
    $DRY_RUN_CMD ${pkgs.crudini}/bin/crudini --set "$conf" Preferences 'General\CustomUIThemePath' "$theme"
  '';

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
}
