{ config, pkgs, ... }:

{
  home.username = "cleboost";
  home.homeDirectory = "/home/cleboost";
  home.stateVersion = "25.05";

  imports = [
    ./modules/shell.nix
    ./modules/hyprland.nix
    ./modules/umbriel.nix
    ./modules/apps.nix
    ./modules/dev.nix
  ];

  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";

    # PRIME / NVIDIA — must live in the user session, not only umbriel [environment].
    # Hyprland injects these via `env =`; autostarted Chrome/Discord are umbriel children
    # and inherit the compositor process environment (see systemd user override below).
    WLR_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "1";
    __GL_MaxFramesAllowed = "1";
    NVD_BACKEND = "direct";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
