# ──────────────────────────────────────────────────────────────────────────────
# nixos/desktop.nix — Hyprland, portals, storage, keyboard
# ──────────────────────────────────────────────────────────────────────────────
{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.cleboost.desktop {
  # ── Window managers ─────────────────────────────────────────────────────────
  # Second session. Greeter default stays Hyprland; pick Umbriel at login.
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    umbriel.enable = true;
    luciole.enable = config.cleboost.file-manager.luciole;
    gpu-screen-recorder.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };

  # ── Keyboard (AZERTY) ───────────────────────────────────────────────────────
  services = {
    xserver.xkb = {
      layout = "fr";
      variant = "";
    };
    udisks2.enable = true;
    gvfs.enable = true;
    # Google Drive in Nautilus: gnome-control-center online-accounts
    gnome.gnome-online-accounts.enable = true;
  };
  console.keyMap = "fr";

  # ── Removable storage & file manager integration ────────────────────────────
  boot.supportedFilesystems = [
    "exfat"
    "ntfs"
  ];

  # Video thumbnails in Nautilus (WebM, MP4, MKV, …)
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
    gnome-control-center
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
      common.default = [
        "hyprland"
        "gtk"
      ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };
}
