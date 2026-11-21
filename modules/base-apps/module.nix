{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.baseApps {
  home.packages = with pkgs; [
    socat
    netcat-openbsd
  ];

  xdg.configFile."hypr/autostart/base-apps.lua".source = ../hyprland/autostart/base-apps.lua;
}
