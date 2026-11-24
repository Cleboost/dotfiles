{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      bun
      nodejs_22
    ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
