# Portable demo. live=true builds the ISO (no hardware-configuration.nix).
{ lib, live ? false, ... }:

{
  imports = [
    ../../system
    ../../system/drivers
    ../../home/hosts/cleboost-demo/groups.nix
  ] ++ lib.optionals (!live) [
    ./hardware-configuration.nix
  ] ++ lib.optionals live [
    ../../system/demo-live.nix
  ];

  networking.hostName = "cleboost-demo";

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  services.netbird.enable = lib.mkForce false;
  virtualisation.docker.enable = lib.mkForce false;

  security.sudo.wheelNeedsPassword = lib.mkOverride 80 true;
}
