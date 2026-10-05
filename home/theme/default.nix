# Look & feel: GTK, Qt, icons, cursor, wallpapers.
{ config, pkgs, ... }:

let
  cleboostIcons = import ./icon-theme.nix { inherit pkgs; };
in
{
  # Wallpapers and profile pictures
  home.file."Pictures/Wallpapers".source = ./wallpapers;
  home.file."Pictures/profile.png".source = ./profile.png;
  home.file."Pictures/banner.png".source = ./banner.png;

  # cleboost-icons: Adwaita + WhiteSur apps only (see icon-theme.nix)
  home.packages = [ cleboostIcons pkgs.adwaita-icon-theme ];

  # GTK: Adwaita-dark + cleboost-icons (Adwaita UI, WhiteSur app icons in launchers only)
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "cleboost-icons";
      package = cleboostIcons;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "cleboost-cursor";
      size = 18;
    };
    gtk3.bookmarks = [
      "file:///home/cleboost/Code Code"
      "file:///home/cleboost/Downloads Downloads"
      "file:///home/cleboost/Pictures Pictures"
      "file:///home/cleboost/Musics Musics"
      "file:///home/cleboost/Videos Videos"
    ];
  };

  # Qt & Kvantum theming
  xdg.configFile."Kvantum".source = ./qt/Kvantum;
  xdg.configFile."qt6ct".source = ./qt/qt6ct;

  # cleboost-cursor: custom Hypr/Wayland cursor
  home.file.".local/share/icons/cleboost-cursor" = {
    source = ./cursor;
    recursive = true;
    force = true;
  };

  # ~/.icons: one symlink for Steam/X11 (do not recursive-link into store — read-only)
  home.activation.removeLegacyIconOverlay = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD rm -rf "$HOME/.local/share/icons/WhiteSur-dark"
    $DRY_RUN_CMD rm -rf "$HOME/.local/share/icons/WhiteSur-dark-cleboost"
  '';

  home.activation.iconsLegacyCursor = config.lib.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.icons"
    $DRY_RUN_CMD rm -rf "$HOME/.icons/cleboost-cursor"
    $DRY_RUN_CMD ln -sfn "$HOME/.local/share/icons/cleboost-cursor" "$HOME/.icons/cleboost-cursor"
  '';

  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=cleboost-cursor
  '';
}
