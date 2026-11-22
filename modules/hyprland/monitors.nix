{ lib, ... }: {
  # 1. Configuration écrans + touchpad + GPU (AMD iGPU) pour le Portable
  flake.modules.nixos.laptop = { ... }: {
    hm.home.sessionVariables = {
      AQ_DRM_DEVICES = "/run/dri/amd-card";
      WLR_DRM_DEVICES = "/run/dri/amd-card";
    };

    hm.wayland.windowManager.hyprland.settings = {
      env = [
        "AQ_DRM_DEVICES,/run/dri/amd-card"
        "WLR_DRM_DEVICES,/run/dri/amd-card"
      ];

      monitor = [
        "eDP-1, 1920x1080@144, 0x0, 1, vrr, 1"
        ", preferred, auto, 1"
      ];

      input.touchpad = {
        natural_scroll = true;
        tap-to-click = true;
        disable_while_typing = true;
        clickfinger_behavior = true;
        scroll_factor = 0.7;
      };
    };
  };

  # 2. Configuration multi-écrans pour la Tour (dual ASUS)
  flake.modules.nixos.tower = { ... }:
    let
      left = "HDMI-A-1";
      right = "DP-3";
      leftDesc = "desc:ASUSTek COMPUTER INC VY279HGE S7LMQS001610";
      rightDesc = "desc:ASUSTek COMPUTER INC VG2791R S3LMDW006158";
    in
    {
      hm.wayland.windowManager.hyprland.settings = {
        monitor = [
          "${leftDesc}, 1920x1080@144, 0x0, 1, vrr, 1"
          "${rightDesc}, 1920x1080@144, 1920x0, 1, vrr, 1"
          "DP-2, 1920x1080@144, 0x0, 1"
          "DP-3, 1920x1080@144, 1920x0, 1"
          "DP-4, 1920x1080@144, 1920x0, 1"
          ", preferred, auto, 1"
        ];

        workspace =
          map (
            w:
            "${toString w}, monitor:${right}${if w == 1 then ", default:true" else ""}"
          ) (lib.range 1 10)
          ++ map (
            w:
            "${toString w}, monitor:${left}${if w == 11 then ", default:true" else ""}"
          ) (lib.range 11 20);
      };
    };
}
