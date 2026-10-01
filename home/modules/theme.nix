{ config, pkgs, ... }:

let
  cleboostIcons = import ./lib/cleboost-icon-theme.nix { inherit pkgs; };
in
{
  # Wallpapers and profile pictures
  home.file."Pictures/Wallpapers".source = ../files/Pictures/Wallpapers;
  home.file."Pictures/profile.png".source = ../files/Pictures/profile.png;
  home.file."Pictures/banner.png".source = ../files/Pictures/banner.png;

  # cleboost-icons: Adwaita + WhiteSur apps only (see lib/cleboost-icon-theme.nix)
  home.packages = [ cleboostIcons pkgs.adwaita-icon-theme ];

  # cleboost-cursor: custom Hypr/Wayland cursor
  home.file.".local/share/icons/cleboost-cursor" = {
    source = ../files/icons/cleboost-cursor;
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
