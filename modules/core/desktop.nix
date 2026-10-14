# ──────────────────────────────────────────────────────────────────────────────
# nixos/desktop.nix — Hyprland, portals, storage, keyboard
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Window managers ─────────────────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.gpu-screen-recorder.enable = true;

  # ── Keyboard (AZERTY) ───────────────────────────────────────────────────────
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  # ── Removable storage & file manager integration ────────────────────────────
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  boot.supportedFilesystems = [ "exfat" "ntfs" ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  # Video thumbnails in Nautilus (WebM, MP4, MKV, …)
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
  ];

  # ── Polkit ──────────────────────────────────────────────────────────────────
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

  # ── XDG desktop portals ─────────────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "hyprland" "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };
}
