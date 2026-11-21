# Luciole est activé au niveau système (programs.luciole) via core/nixos/_desktop.nix.
# Ce module est prêt pour accueillir d'éventuelles configs utilisateur Home Manager.
{ lib, osConfig, ... }:

lib.mkIf osConfig.cleboost.file-manager.luciole { }
