{ config, lib, pkgs, ... }:

{
  imports = [
    ../config/zapfast/module.nix
  ];

  config = lib.mkIf (lib.elem "social" config.cleboost.groups) {
    home.packages = with pkgs; [
      telegram-desktop
      zapfast
      discord
      spotifast
    ];

    xdg.configFile."hypr/autostart/social.lua".source = ../config/hyprland/autostart/social.lua;

    xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "discord.desktop";
  };
}
