{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.social.discord {
  home.packages = with pkgs; [
    discord
    vesktop
  ];

  xdg = {
    configFile."hypr/autostart/social.lua".source = ../hyprland/autostart/social.lua;
    mimeApps.defaultApplications."x-scheme-handler/discord" = "discord.desktop";
  };
}
