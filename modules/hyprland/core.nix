{ ... }: {
  flake.modules.nixos.desktop = { pkgs, ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    hm.wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;

      settings = {
        env = [
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "XDG_DATA_DIRS,/home/cleboost/.local/share:/etc/profiles/per-user/cleboost/share:/run/current-system/sw/share:/usr/share"
          "TERMINAL,$HOME/.config/hypr/scripts/open-terminal.sh"
          "NAUTILUS_4_EXTENSION_DIR,/run/current-system/sw/lib/nautilus/extensions-4"
          "QT_QPA_PLATFORM,wayland"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "QT_STYLE_OVERRIDE,kvantum"
          "GTK_ICON_THEME,cleboost-icons"
          "GTK_USE_PORTAL,0"
          "GSK_RENDERER,gl"
          "XCURSOR_THEME,cleboost-cursor"
          "XCURSOR_SIZE,18"
          "HYPRCURSOR_THEME,cleboost-cursor"
          "HYPRCURSOR_SIZE,18"
        ];

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 4;
          layout = "dwindle";
          allow_tearing = true;
        };

        decoration = {
          rounding = 18;
          blur = {
            enabled = true;
            size = 10;
            passes = 3;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 5, myBezier"
            "workspaces, 1, 4, default"
          ];
        };

        input = {
          kb_layout = "fr,us";
          follow_mouse = 1;
          sensitivity = 0;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };
    };
  };
}
