{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { ... }: {
    hm.imports = [ ./_files ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
