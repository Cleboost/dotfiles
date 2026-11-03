# Paquets Home Manager uniquement sur la clé USB (PR nixpkgs #580999, pas encore merge).
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (callPackage ../../pkgs/horizon-launcher.nix { })
  ];
}
