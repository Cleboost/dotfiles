# Tower — hardware and system only.
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

  # Intel I211 — primary Ethernet when cable is plugged in
  networking.firewall.trustedInterfaces = [ "enp5s0" ];

  # Titan X Pascal → legacy 580 branch (6xx driver rejects the card)
  drivers.nvidia = {
    enable = true;
    packageFlavour = "legacy_580";
    coolbits = 4; # ventilo manuel via nvidia-settings
  };

  boot.kernelParams = [
    "pcie_aspm.policy=performance"
  ];

  boot.kernelModules = lib.mkAfter [ "kvm-amd" ];
}
