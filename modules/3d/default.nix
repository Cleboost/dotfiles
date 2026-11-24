{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      blockbench
      blender
    ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
