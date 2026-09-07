# Module Hyprland & Environnement de bureau
{ config, pkgs, ... }:

{
  # Gestionnaire de fenêtres Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Clavier AZERTY pour X11 / Wayland et la console
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  # Accès aux périphériques et polkit
  security.polkit.enable = true;
}
