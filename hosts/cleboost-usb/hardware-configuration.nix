# Placeholder pour que le flake évalue. Ne pas booter avec ce fichier :
# après partitionnement de la clé, lancer system/scripts/install-usb.sh --apply
# depuis un NixOS déjà installé sur la clé (ou après nixos-install manuel).
{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
