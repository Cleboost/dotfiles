{ config, pkgs, ... }:

{
  # Link individual hypr files and folders so ~/.config/hypr remains writable (for noctalia theme generation)
  xdg.configFile."hypr/hyprland.conf".source = ../files/hypr/hyprland.conf;
  xdg.configFile."hypr/hypridle.conf".source = ../files/hypr/hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".source = ../files/hypr/hyprlock.conf;
  xdg.configFile."hypr/custom.conf".source = ../files/hypr/custom.conf;
  xdg.configFile."hypr/core".source = ../files/hypr/core;
  xdg.configFile."hypr/binds".source = ../files/hypr/binds;
  xdg.configFile."hypr/rules".source = ../files/hypr/rules;
  xdg.configFile."hypr/theme".source = ../files/hypr/theme;
  xdg.configFile."hypr/hyprland".source = ../files/hypr/hyprland;
  xdg.configFile."hypr/hyprlock".source = ../files/hypr/hyprlock;
  xdg.configFile."hypr/scripts".source = ../files/hypr/scripts;
  xdg.configFile."hypr/move-special.sh".source = ../files/hypr/move-special.sh;

  # User custom scripts into ~/.local/bin
  home.file.".local/bin".source = ../files/bin;
  home.file.".local/bin".recursive = true;

  # Icons & Wallpapers
  home.file.".local/share/icons".source = ../files/icons;
  home.file.".local/share/icons".recursive = true;

  home.file."Pictures/Wallpapers".source = ../files/Pictures/Wallpapers;
  home.file."Pictures/profile.png".source = ../files/Pictures/profile.png;
  home.file."Pictures/banner.png".source = ../files/Pictures/banner.png;
}
