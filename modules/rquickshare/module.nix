{
  xdg.dataFile."dev.mandre.rquickshare/.settings.json" = {
    force = true;
    text = builtins.toJSON {
      autostart = false;
      visibility = 0;
      startminimized = true;
      realclose = false;
    };
  };
}
