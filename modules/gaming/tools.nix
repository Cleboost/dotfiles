{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      gamescope
      prismlauncher
      protontricks
    ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
