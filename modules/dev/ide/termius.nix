{ lib, ... }:
let
  hosts = [ "tour" ];
  mod = { pkgs, ... }: {
    hm.home.packages = [ pkgs.termius ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
