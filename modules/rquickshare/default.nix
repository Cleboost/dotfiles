{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
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
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
