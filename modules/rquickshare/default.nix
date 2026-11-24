{ ... }: {
  flake.modules.nixos.desktop = { pkgs, ... }: {
    hm = {
      home.packages = [ pkgs.rquickshare ];

      xdg.dataFile."dev.mandre.rquickshare/.settings.json" = {
        force = true;
        text = builtins.toJSON {
          autostart = false;
          visibility = 0;
          startminimized = true;
          realclose = false;
        };
      };
    };
  };
}
