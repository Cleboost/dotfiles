# Tour — matériel et système uniquement.
{ lib, ... }:

{
  imports = [
    ../../system
    ../../system/drivers
    ../../home/hosts/cleboost-brain/groups.nix
    ./hardware-configuration.nix
    ./storage.nix
    ./ugreen-wifi.nix
  ];

  networking.hostName = "cleboost-brain";

  # Intel I211 — primary Ethernet when câble branché
  networking.firewall.trustedInterfaces = [ "enp5s0" ];

  # Titan X Pascal → branche legacy 580 (driver 6xx refuse la carte)
  drivers.nvidia = {
    enable = true;
    packageFlavour = "legacy_580";
  };

  boot.kernelParams = [
    "pcie_aspm.policy=performance"
  ];

  boot.kernelModules = lib.mkAfter [ "kvm-amd" ];
}
