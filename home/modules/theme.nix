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
  home.file.".local/share/icons/cleboost-cursor".source = ../files/icons/cleboost-cursor;
  home.file.".local/share/icons/WhiteSur-dark".source = ../files/icons/WhiteSur-dark;

  # ~/.icons for Steam, XWayland, and other non-XDG cursor lookups (same cursor theme)
  home.file.".icons/cleboost-cursor".source = ../files/icons/cleboost-cursor;
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=cleboost-cursor
  '';
}
