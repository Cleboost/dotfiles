# NixOS sur clé USB : ne pas toucher au NVRAM du PC hôte, matos générique.
{ lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # Kernel récent + firmware large pour PC d'école / invités inconnus.
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  hardware.enableAllHardware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
}
