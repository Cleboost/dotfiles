# Diff Noctalia live / invité. Le reste est dans modules/home/desktop/noctalia/settings.nix.
{ lib, base, ... }:

let
  noFan = lib.removeAttrs base.widget [ "fan-control" ];
in
base // {
  bar = base.bar // {
    main = base.bar.main // {
      center = [ "media" ];
    };
  };

  widget = noFan // {
    cat = base.widget.cat // {
      input_devices = [ ];
    };
  };

  desktop_widgets = base.desktop_widgets // {
    enabled = false;
  };

  plugins = base.plugins // {
    enabled = [
      "noctalia/bongocat"
      "noctalia/screen_recorder"
    ];
  };
}
