{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "social" config.cleboost.groups) {
  home.packages = with pkgs; [
    telegram-desktop
    zapfast
    discord
    spotifast
  ];

  xdg.configFile."hypr/autostart/social.lua".source = ./hypr-autostart.lua;

  xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "discord.desktop";
}
