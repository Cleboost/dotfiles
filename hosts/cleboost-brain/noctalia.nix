# Noctalia overrides — tour (pas de fan ASUS, widgets sur DP-1)
{ ... }:

{
  cleboost.noctalia = {
    bar.center = [ "media" ];
    fanControl.enable = false;
    bongocat.inputDevices = [ ];
    desktopWidgets.output = "DP-1";
    plugins.enabled = [
      "noctalia/bongocat"
      "noctalia/screen_recorder"
      "cleboost/anilist"
      "cleboost/librelinkup"
    ];
  };
}
