{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      jetbrains.idea
      jdk21
      maven
      gradle
    ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
