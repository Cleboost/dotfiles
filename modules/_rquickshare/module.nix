{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.rquickshare {
  home.packages = [ pkgs.rquickshare ];

  xdg.dataFile."dev.mandre.rquickshare/.settings.json".text = builtins.toJSON {
    autostart = false;
    realclose = false;
    startminimized = true;
    visibility = "visible";
  };
}
