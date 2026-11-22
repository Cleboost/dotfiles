{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    hm.wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";

      bind = [
        # Applications
        "$mod, Return, exec, kitty"
        "$mod, T, exec, ~/.config/hypr/scripts/open-terminal.sh"
        "$mod, E, exec, luciole"
        "$mod, W, exec, google-chrome-stable"
        "$mod, C, exec, cursor"
        "$mod, O, exec, obsidian"
        "$mod, A, exec, kitty agy"
        "$mod SHIFT, A, exec, kitty agy --continue"
        "$mod, Space, exec, noctalia-shell ipc call launcher toggle"

        # Utilitaires (Screenshots & Tools)
        "$mod SHIFT, S, exec, noctalia msg screenshot-region"
        "$mod SHIFT, D, exec, noctalia msg screenshot-annotate"
        ", Print, exec, noctalia msg screenshot-annotate"
        "SHIFT, Print, exec, noctalia msg screenshot-fullscreen"
        "$mod SHIFT, C, exec, hyprpicker -a"
        "$mod, H, exec, ~/.config/hypr/scripts/hotspot.sh"

        # Zoom & Écran
        "$mod, Z, exec, ~/.config/hypr/scripts/cursor_zoom.sh up"
        "$mod SHIFT, Z, exec, ~/.config/hypr/scripts/cursor_zoom.sh reset"

        # Gestion des fenêtres
        "$mod, Q, killactive"
        "$mod, F, fullscreen, 0"
        "$mod ALT, space, togglefloating"
        "$mod SHIFT ALT, Q, exec, hyprctl kill"

        # Navigation focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, bracketleft, movefocus, l"
        "$mod, bracketright, movefocus, r"

        # Déplacement des fenêtres
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Workspaces (rangée chiffres AZERTY / keycodes 10-19)
        "$mod, code:10, workspace, 1"
        "$mod, code:11, workspace, 2"
        "$mod, code:12, workspace, 3"
        "$mod, code:13, workspace, 4"
        "$mod, code:14, workspace, 5"
        "$mod, code:15, workspace, 6"
        "$mod, code:16, workspace, 7"
        "$mod, code:17, workspace, 8"
        "$mod, code:18, workspace, 9"
        "$mod, code:19, workspace, 10"

        # Déplacer fenêtre vers workspace (silencieux)
        "$mod ALT, code:10, movetoworkspacesilent, 1"
        "$mod ALT, code:11, movetoworkspacesilent, 2"
        "$mod ALT, code:12, movetoworkspacesilent, 3"
        "$mod ALT, code:13, movetoworkspacesilent, 4"
        "$mod ALT, code:14, movetoworkspacesilent, 5"
        "$mod ALT, code:15, movetoworkspacesilent, 6"
        "$mod ALT, code:16, movetoworkspacesilent, 7"
        "$mod ALT, code:17, movetoworkspacesilent, 8"
        "$mod ALT, code:18, movetoworkspacesilent, 9"
        "$mod ALT, code:19, movetoworkspacesilent, 10"

        # Navigation workspaces directionnelle & souris
        "CTRL $mod, right, workspace, r+1"
        "CTRL $mod, left, workspace, r-1"
        "$mod, Page_Down, workspace, +1"
        "$mod, Page_Up, workspace, -1"
        "CTRL $mod, mouse_up, workspace, r+1"
        "CTRL $mod, mouse_down, workspace, r-1"
        "CTRL $mod, bracketleft, workspace, -1"
        "CTRL $mod, bracketright, workspace, +1"

        # Déplacer fenêtre entre workspaces
        "$mod SHIFT, mouse_down, movetoworkspace, r-1"
        "$mod SHIFT, mouse_up, movetoworkspace, r+1"
        "$mod ALT, mouse_down, movetoworkspace, -1"
        "$mod ALT, mouse_up, movetoworkspace, +1"
        "$mod ALT, Page_Down, movetoworkspace, +1"
        "$mod ALT, Page_Up, movetoworkspace, -1"
        "$mod ALT, right, movetoworkspace, +1"
        "$mod ALT, left, movetoworkspace, -1"
        "$mod SHIFT, Page_Down, movetoworkspace, r+1"
        "$mod SHIFT, Page_Up, movetoworkspace, r-1"
        "CTRL $mod SHIFT, right, movetoworkspace, r+1"
        "CTRL $mod SHIFT, left, movetoworkspace, r-1"

        # Special Workspaces
        "$mod, D, togglespecialworkspace, comm"
        "$mod, S, togglespecialworkspace, music"
        "$mod SHIFT, W, exec, ~/.config/hypr/scripts/manage_workspaces.sh --once"

        # Noctalia Shell & Système
        "CTRL $mod, T, exec, noctalia msg panel-toggle wallpaper"
        "$mod, comma, exec, noctalia msg settings-toggle"
        "CTRL ALT, Delete, exec, noctalia msg panel-toggle session"
        "CTRL $mod, Delete, exec, noctalia msg panel-toggle session"
        "$mod, V, exec, noctalia msg panel-toggle clipboard"
        "$mod, semicolon, exec, noctalia msg panel-toggle launcher \"/emo\""
        "$mod, L, exec, noctalia msg session lock"
        "$mod, F5, exec, noctalia msg power-cycle"
        "$mod, mouse:275, exec, noctalia msg media previous"
        "$mod, mouse:276, exec, noctalia msg media next"
        "CTRL $mod ALT, R, exec, pkill noctalia; noctalia"
        "CTRL SHIFT $mod ALT, R, exec, pkill noctalia"
        "CTRL $mod ALT, T, exec, noctalia msg wallpaper-random"
        "$mod, R, exec, noctalia msg plugin noctalia/screen_recorder:service all toggle"
      ];

      # Launcher au relâchement de Super
      bindr = [
        "$mod, Super_L, exec, noctalia msg panel-toggle launcher"
        "$mod, Super_R, exec, noctalia msg panel-toggle launcher"
      ];

      # Molette sur workspaces (répétition)
      binde = [
        "$mod, mouse_up, workspace, e-1"
        "$mod, mouse_down, workspace, e+1"
      ];

      # Pavé numérique (locked) + Médias (locked)
      bindl = [
        "$mod, code:87, workspace, 1"
        "$mod, code:88, workspace, 2"
        "$mod, code:89, workspace, 3"
        "$mod, code:83, workspace, 4"
        "$mod, code:84, workspace, 5"
        "$mod, code:85, workspace, 6"
        "$mod, code:79, workspace, 7"
        "$mod, code:80, workspace, 8"
        "$mod, code:81, workspace, 9"
        "$mod, code:90, workspace, 10"

        "$mod SHIFT, P, exec, playerctl play-pause"
        "$mod SHIFT, N, exec, playerctl next"
        "$mod SHIFT, B, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        "$mod SHIFT ALT, mouse:275, exec, playerctl previous"
        "$mod SHIFT ALT, mouse:276, exec, playerctl next"

        ", XF86AudioMute, exec, noctalia msg volume-mute"
        ", XF86AudioMicMute, exec, noctalia msg mic-mute"
        "$mod SHIFT, M, exec, noctalia msg mic-mute"
      ];

      # Volume & Luminosité (locked + repeating)
      bindel = [
        ", XF86AudioRaiseVolume, exec, noctalia msg volume-up"
        ", XF86AudioLowerVolume, exec, noctalia msg volume-down"
        ", XF86MonBrightnessUp, exec, noctalia msg brightness-up"
        ", XF86MonBrightnessDown, exec, noctalia msg brightness-down"
      ];

      # Déplacement / redimensionnement à la souris
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, mouse:274, movewindow"
      ];
    };
  };
}
