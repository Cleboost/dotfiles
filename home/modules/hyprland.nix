{ config, pkgs, ... }:

{
  # Hyprland: Lua-only config. Individual links keep ~/.config/hypr writable for Noctalia.
  xdg.configFile."hypr/hyprland.lua" = {
    source = ../files/hypr/hyprland.lua;
    force = true;
  };
  xdg.configFile."hypr/custom.lua".source = ../files/hypr/custom.lua;
  xdg.configFile."hypr/core" = {
    source = ../files/hypr/core;
    force = true;
  };
  xdg.configFile."hypr/binds".source = ../files/hypr/binds;
  xdg.configFile."hypr/rules".source = ../files/hypr/rules;
  xdg.configFile."hypr/theme".source = ../files/hypr/theme;
  xdg.configFile."hypr/scripts".source = ../files/hypr/scripts;
  xdg.configFile."hypr/move-special.sh".source = ../files/hypr/move-special.sh;
}
