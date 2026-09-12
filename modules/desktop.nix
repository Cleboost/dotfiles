# Hyprland & Desktop Environment Module
{ config, pkgs, ... }:

{
  # Hyprland window manager
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # GPU Screen Recorder with setuid/cap wrapper for KMS screen capture
  programs.gpu-screen-recorder.enable = true;

  # AZERTY keyboard layout for X11 / Wayland and console
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  # Hardware access & polkit
  security.polkit.enable = true;

  # XDG Desktop Portals (Screensharing, window streaming, file picker)
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };
}
