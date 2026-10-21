# Tour — barre minimaliste, pas de ventilo EC, encodeur screen recorder en CPU.
{ lib, base, ... }:

base // {
  bar = base.bar // {
    main = base.bar.main // {
      start = [
        "control-center"
        "workspaces"
      ];
      center = [
        "clock"
      ];
      end = [
        "tray"
        "recorder"
        "notifications"
        "session"
      ];
    };
  };

  widget = base.widget // {
    clock = {
      capsule = true;
    };
    "control-center" = {
      capsule = true;
      custom_image = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
      custom_image_colorize = true;
      glyph = "";
    };
    recorder = base.widget.recorder // {
      capsule = true;
    };
  };

  desktop_widgets = base.desktop_widgets // {
    widget = lib.mapAttrs (_: widget: widget // { output = "DP-1"; }) base.desktop_widgets.widget;
  };

  plugins = base.plugins // {
    enabled = base.plugins.enabled ++ [
      "cleboost/anilist"
      "cleboost/librelinkup"
    ];
  };

  # Titan X + legacy_580 : NVENC API 13.0 vs FFmpeg 13.1 → encode GPU mort, CPU OK.
  plugin_settings = base.plugin_settings // {
    "noctalia/screen_recorder" =
      base.plugin_settings."noctalia/screen_recorder" // {
        video_encoder = "cpu";
      };
  };
}
