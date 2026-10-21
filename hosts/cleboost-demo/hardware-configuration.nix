# Only a placeholder for flake evaluation. Do NOT boot an installed system
# with this file: system/scripts/install-demo.sh replaces it with hardware detection
# performed by NixOS on the actual target PC.
{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
