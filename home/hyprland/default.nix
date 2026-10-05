# ──────────────────────────────────────────────────────────────────────────────
# home/hyprland/default.nix — Hyprland config (Lua); per-file links for Noctalia
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.lua" = {
    source = ./hyprland.lua;
    force = true;
  };
  xdg.configFile."hypr/custom.lua".source = ./custom.lua;
  xdg.configFile."hypr/core" = {
    source = ./core;
    force = true;
  };
  xdg.configFile."hypr/binds".source = ./binds;
  xdg.configFile."hypr/rules".source = ./rules;
  xdg.configFile."hypr/theme".source = ./theme;
  xdg.configFile."hypr/scripts".source = ./scripts;
  xdg.configFile."hypr/move-special.sh".source = ./move-special.sh;
}
