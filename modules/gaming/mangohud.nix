{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm.home.packages = [ pkgs.mangohud ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
