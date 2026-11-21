{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.social {
  home.packages = with pkgs; [
    telegram-desktop
    zapfast
    discord
    vesktop
    spotify
  ];

  xdg = {
    configFile."hypr/autostart/social.lua".source = ../hyprland/autostart/social.lua;
    mimeApps.defaultApplications."x-scheme-handler/discord" = "discord.desktop";
  };
}
