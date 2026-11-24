{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    programs.nix-ld.enable = true;

    hm.home.packages = with pkgs; [
      rustup
      just
    ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
