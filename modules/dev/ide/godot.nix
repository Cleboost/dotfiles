{ lib, ... }:
let
  hosts = [ "tour" ];
  mod = { pkgs, ... }: {
    hm.home.packages = [ pkgs.godot_4 ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
