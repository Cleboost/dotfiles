{ config, pkgs, ... }:

{
  # User custom scripts into ~/.local/bin
  home.file.".local/bin".source = ../files/bin;
  home.file.".local/bin".recursive = true;

  # Wallpapers and profile pictures
  home.file."Pictures/Wallpapers".source = ../files/Pictures/Wallpapers;
  home.file."Pictures/profile.png".source = ../files/Pictures/profile.png;
  home.file."Pictures/banner.png".source = ../files/Pictures/banner.png;

  # Icons
  home.file.".local/share/icons".source = ../files/icons;
  home.file.".local/share/icons".recursive = true;

  # Legacy X11/XWayland ~/.icons support (essential for Steam and older 32-bit apps)
  home.file.".icons/cleboost-cursor".source = ../files/icons/cleboost-cursor;
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=cleboost-cursor
  '';
}
