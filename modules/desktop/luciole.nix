{ inputs, lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = {
    imports = [ inputs.luciole.nixosModules.default ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
