{ config, pkgs, ... }:

{
  # Link full hypr directory
  xdg.configFile."hypr".source = ../files/hypr;

  # User custom scripts into ~/.local/bin
  home.file.".local/bin".source = ../files/bin;
  home.file.".local/bin".recursive = true;

  # Icons & Wallpapers
  home.file.".local/share/icons".source = ../files/icons;
  home.file.".local/share/icons".recursive = true;

  home.file."Pictures/Wallpapers".source = ../files/Pictures/exact_Wallpapers;
  home.file."Pictures/profile.png".source = ../files/Pictures/profile.png;
  home.file."Pictures/banner.png".source = ../files/Pictures/banner.png;
}
