{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { ... }: {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
