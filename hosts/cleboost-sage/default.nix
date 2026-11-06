# Laptop — matériel et système uniquement.
{ ... }:

{
  imports = [
    ../../system
    ../../system/drivers
    ../../home/hosts/cleboost-sage/groups.nix
    ./hardware-configuration.nix
  ];

  drivers.nvidia = {
    enable = true;
    prime.enable = true;
  };
  drivers.asus-fan-control.enable = true;

  networking.hostName = "cleboost-sage";
  networking.firewall.trustedInterfaces = [ "wlp3s0" ];

  hardware.flipperzero.enable = true;
}
