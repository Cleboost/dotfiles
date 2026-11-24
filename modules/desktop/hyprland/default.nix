{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    hm.imports = [ ./_module.nix ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
