{ ... }: {
  flake.modules.nixos.tour = { lib, ... }: {
    hm.programs.noctalia.settings = {
      bar.main = {
        start = lib.mkForce [
          "control-center"
          "workspaces"
        ];
        center = lib.mkForce [
          "clock"
        ];
        end = lib.mkForce [
          "tray"
          "recorder"
          "notifications"
          "session"
        ];
      };

      widget = {
        clock = {
          capsule = true;
        };
        "control-center" = {
          capsule = true;
          custom_image = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          custom_image_colorize = true;
          glyph = "";
        };
        recorder = {
          capsule = true;
        };
      };

      desktop_widgets.widget = {
        desktop_clock.output = lib.mkForce "DP-1";
        desktop_audio_visualizer.output = lib.mkForce "DP-1";
        desktop_media_player.output = lib.mkForce "DP-1";
        desktop_weather.output = lib.mkForce "DP-1";
      };

      plugins.enabled = [
        "cleboost/anilist"
        "cleboost/librelinkup"
      ];

      # Titan X + legacy_580 : NVENC API 13.0 vs FFmpeg 13.1 → encode GPU mort, CPU OK.
      plugin_settings."noctalia/screen_recorder".video_encoder = "cpu";
    };
  };
}
