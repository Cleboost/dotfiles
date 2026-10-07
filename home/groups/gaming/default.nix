{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "gaming" config.cleboost.groups) {
  home.packages = with pkgs; [
    prismlauncher
    beammp-launcher
    mangohud
    gamescope
    protontricks
    vkbasalt
  ];

  xdg.configFile."MangoHud/MangoHud.conf".source = ./mangohud/MangoHud.conf;
  xdg.configFile."hypr/autostart/gaming.lua".source = ./hypr-autostart.lua;
}
