{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { ... }: {
    hm.imports = [ ./_base.nix ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
