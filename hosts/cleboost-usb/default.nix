# Linux persistant sur clé USB — boot invité, flake + Home Manager complets.
{ lib, ... }:

{
  imports = [
    ../../system
    ../../system/drivers
    ../../system/usb.nix
    ../../home/hosts/cleboost-usb/groups.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "cleboost-usb";

  # Pas de VPN / Docker sur une clé emportée (réseau lycée, ressources limitées).
  services.netbird.enable = lib.mkForce false;
  virtualisation.docker.enable = lib.mkForce false;
}
