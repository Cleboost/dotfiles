# Hyprland & Desktop Environment Module
{ config, pkgs, ... }:

{
  # Hyprland window manager
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # AZERTY keyboard layout for X11 / Wayland and console
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  # Hardware access & polkit
  security.polkit.enable = true;
}
