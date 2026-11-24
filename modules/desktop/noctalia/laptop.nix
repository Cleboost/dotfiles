{ ... }: {
  flake.modules.nixos.laptop = { lib, ... }: {
    hm.programs.noctalia.settings = {
      bar.main = {
        start = lib.mkForce [
          "control-center"
          "workspaces"
        ];
        center = lib.mkForce [
          "media"
          "fan-control"
        ];
        end = lib.mkForce [
          "tray"
          "recorder"
          "battery"
          "notifications"
          "clock"
        ];
      };

      widget = {
        "fan-control" = {
          type = "cleboost/asus-fans-controller-ec:fan-control";
          show_label = true;
        };
        cat = {
          type = "noctalia/bongocat:cat";
          input_devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          ];
          audio_spectrum = false;
        };
        anilist = {
          type = "cleboost/anilist:tracker";
        };
        glucose = {
          type = "cleboost/librelinkup:glucose";
        };
        battery = {
          display_mode = "graphic";
          hide_when_plugged = true;
        };
      };

      plugins.enabled = [
        "cleboost/anilist"
        "cleboost/asus-fans-controller-ec"
        "cleboost/librelinkup"
      ];
    };
  };
}
