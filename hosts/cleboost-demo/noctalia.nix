# Noctalia overrides — machine invitée / live
{ ... }:

{
  cleboost.noctalia = {
    bar.center = [ "media" ];
    fanControl.enable = false;
    bongocat.inputDevices = [ ];
    desktopWidgets.enable = false;
    plugins.enabled = [
      "noctalia/bongocat"
      "noctalia/screen_recorder"
    ];
  };
}
