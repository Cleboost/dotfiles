# Laptop ASUS — ventilos EC, bongocat clavier, trackers perso.
{ base, ... }:

base // {
  bar = base.bar // {
    main = base.bar.main // {
      start = [
        "cpu"
        "temp"
        "ram"
        "workspaces"
      ];
      center = [
        "media"
        "fan-control"
      ];
      end = [
        "cat"
        "recorder"
        "notifications"
        "tray"
        "clock"
        "control-center"
      ];
    };
  };

  widget = base.widget // {
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
  };

  plugins = base.plugins // {
    enabled = base.plugins.enabled ++ [
      "cleboost/anilist"
      "cleboost/asus-fans-controller-ec"
      "cleboost/librelinkup"
    ];
  };
}
