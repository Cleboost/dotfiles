{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      # C/C++ (fournit `cc` pour Cargo/Rust)
      gcc
      gnumake

      # Nix
      nixd
      nix-update
    ];
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
