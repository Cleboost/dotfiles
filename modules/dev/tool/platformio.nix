{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    services.udev.packages = [ pkgs.platformio-core.udev ];
    hm.home.packages = [ pkgs.platformio ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
