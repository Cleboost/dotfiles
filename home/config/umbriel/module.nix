# Première session Umbriel. Le thème fin se règle une fois dedans.
# Définir [keybinds] remplace la liste livrée avec Umbriel : tout garder ici.
{ hostName, lib, ... }:

{
  programs.umbriel = {
    enable = true;
    settings = {
      general = {
        autostart = [ "noctalia" ];
        show_cheatsheet = false;
        xwayland = true;
      };
    } // lib.optionalAttrs (hostName == "cleboost-sage") {
      drm = {
        # Même idée que Hyprland : le bureau reste sur l'iGPU AMD.
        ignored_pci_addresses = [ "0000:01:00.0" ];
      };
    } // {

      appearance = {
        border_width = 4;
        corner_radius = 18;
        blur = {
          enabled = true;
          passes = 3;
          radius = 10;
          noise = 0.0;
          brightness = 1.0;
          contrast = 0.9;
        };
        shadow.enabled = false;
      };

      input.keyboard = {
        layout = "fr";
        numlock_toggle = true;
      };

      layout = {
        mode = "dwindle";
        gap = 8;
      };

      keybinds = {
        "Mod" = "spawn noctalia msg panel-toggle launcher";
        "Mod+T" = "spawn kitty";
        "Mod+E" = "spawn nautilus -w";
        "Mod+W" = "spawn google-chrome-stable";
        "Mod+C" = "spawn cursor";
        "Mod+O" = "spawn obsidian";
        "Mod+A" = "spawn kitty agy";
        "Mod+Shift+A" = "spawn kitty agy --continue";
        "Mod+Q" = { action = "window-close"; repeat = false; };
        "Mod+F" = { action = "window-toggle-fullscreen"; repeat = false; };
        "Mod+Alt+Space" = { action = "window-toggle-floating"; repeat = false; };
        "Mod+L" = "spawn noctalia msg session lock";
        "Mod+V" = "spawn noctalia msg panel-toggle clipboard";
        "Mod+comma" = "spawn noctalia msg settings-toggle";
        "Mod+Shift+S" = "spawn noctalia msg screenshot-region";
        "Print" = "spawn noctalia msg screenshot-annotate";
        "Shift+Print" = "spawn noctalia msg screenshot-fullscreen";
        "Mod+R" = "spawn noctalia msg plugin noctalia/screen_recorder:service all toggle";
        "Ctrl+Alt+Delete" = "spawn noctalia msg panel-toggle session";
        "Ctrl+Super+Alt+R" = "spawn pkill noctalia; noctalia";

        "Mod+Left" = "window-focus-left";
        "Mod+Right" = "window-focus-right";
        "Mod+Up" = "window-focus-up";
        "Mod+Down" = "window-focus-down";
        "Mod+Shift+Left" = "column-move-left";
        "Mod+Shift+Right" = "column-move-right";
        "Mod+Shift+Up" = "window-move-up";
        "Mod+Shift+Down" = "window-move-down";

        "Mod+1" = "workspace-switch 1";
        "Mod+2" = "workspace-switch 2";
        "Mod+3" = "workspace-switch 3";
        "Mod+4" = "workspace-switch 4";
        "Mod+5" = "workspace-switch 5";
        "Mod+6" = "workspace-switch 6";
        "Mod+7" = "workspace-switch 7";
        "Mod+8" = "workspace-switch 8";
        "Mod+9" = "workspace-switch 9";
        "Mod+Shift+1" = "window-move-to-workspace 1";
        "Mod+Shift+2" = "window-move-to-workspace 2";
        "Mod+Shift+3" = "window-move-to-workspace 3";
        "Mod+Shift+4" = "window-move-to-workspace 4";
        "Mod+Shift+5" = "window-move-to-workspace 5";
        "Mod+Shift+6" = "window-move-to-workspace 6";
        "Mod+Shift+7" = "window-move-to-workspace 7";
        "Mod+Shift+8" = "window-move-to-workspace 8";
        "Mod+Shift+9" = "window-move-to-workspace 9";

        "XF86AudioRaiseVolume" = { action = "spawn noctalia msg volume-up"; allow_when_locked = true; };
        "XF86AudioLowerVolume" = { action = "spawn noctalia msg volume-down"; allow_when_locked = true; };
        "XF86AudioMute" = { action = "spawn noctalia msg volume-mute"; allow_when_locked = true; repeat = false; };
        "XF86AudioPlay" = { action = "spawn noctalia msg media toggle"; allow_when_locked = true; repeat = false; };
        "XF86AudioNext" = { action = "spawn noctalia msg media next"; allow_when_locked = true; };
        "XF86AudioPrev" = { action = "spawn noctalia msg media previous"; allow_when_locked = true; };
        "XF86MonBrightnessUp" = { action = "spawn noctalia msg brightness-up"; allow_when_locked = true; };
        "XF86MonBrightnessDown" = { action = "spawn noctalia msg brightness-down"; allow_when_locked = true; };
      };

      window_rule = [
        { blur = true; }
        {
          match.app_id = "^dev.noctalia.Noctalia$";
          default_floating = true;
        }
      ];

      layer_rule = [
        {
          match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
          blur = true;
          blur_ignore_alpha = 0.5;
        }
      ];
    };
  };
}
