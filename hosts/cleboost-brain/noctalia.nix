# Diff Noctalia de la tour. Le reste est dans modules/home/desktop/noctalia/settings.nix.
{ lib, base, ... }:

let
  noFan = lib.removeAttrs base.widget [ "fan-control" ];
in
base // {
  bar = base.bar // {
    main = base.bar.main // {
      center = [
        "media"
        "anilist"
        "glucose"
      ];
    };
  };

  widget = noFan // {
    cat = base.widget.cat // {
      input_devices = [ ];
    };
  };

  desktop_widgets = base.desktop_widgets // {
    widget = lib.mapAttrs (_: widget: widget // { output = "DP-1"; }) base.desktop_widgets.widget;
  };

  plugins = base.plugins // {
    enabled = [
      "noctalia/bongocat"
      "noctalia/screen_recorder"
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
