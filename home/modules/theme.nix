{ config, pkgs, ... }:

{
  # Wallpapers and profile pictures
  home.file."Pictures/Wallpapers".source = ../files/Pictures/Wallpapers;
  home.file."Pictures/profile.png".source = ../files/Pictures/profile.png;
  home.file."Pictures/banner.png".source = ../files/Pictures/banner.png;

  # Icons (see home/modules/apps.nix gtk.iconTheme — full theme from nixpkgs)
  #
  # - cleboost-cursor: custom Hypr/Wayland cursor (~19M, only thing we vendor at full size)
  # - WhiteSur-dark: tiny overlay (places/ only) — inherits pkgs.whitesur-icon-theme for everything else
  home.file.".local/share/icons/cleboost-cursor" = {
    source = ../files/icons/cleboost-cursor;
    recursive = true;
    force = true;
  };
  home.file.".local/share/icons/WhiteSur-dark" = {
    source = ../files/icons/WhiteSur-dark;
    recursive = true;
    force = true;
  };

  # ~/.icons: one symlink for Steam/X11 (do not recursive-link into store — read-only)
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
