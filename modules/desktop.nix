# Hyprland & Desktop Environment Module
{ config, pkgs, ... }:

{
  # Hyprland window manager
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Umbriel window manager (Wayland compositor by Noctalia)
  programs.umbriel.enable = true;

  # GPU Screen Recorder with setuid/cap wrapper for KMS screen capture
  programs.gpu-screen-recorder.enable = true;

  # AZERTY keyboard layout for X11 / Wayland and console
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  # Removable storage & file manager integration (USB, Nautilus, trash, mtp)
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  boot.supportedFilesystems = [ "exfat" "ntfs" ];

  # Nautilus terminal extension (Open in Kitty via right click)
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  # Hardware access & polkit
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id.indexOf("org.freedesktop.UPower.PowerProfiles.") === 0 ||
        action.id.indexOf("net.hadess.PowerProfiles.") === 0 ||
        action.id.indexOf("org.freedesktop.upower.") === 0
      ) {
        if (subject.isInGroup("users") || subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      }
    });
  '';

  # XDG Desktop Portals (screensharing, window streaming, file picker)
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "hyprland" "gtk" ];
      umbriel.default = [ "umbriel" "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };
}
