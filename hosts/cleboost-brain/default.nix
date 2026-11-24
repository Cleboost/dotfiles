# Tower — hardware and system only.
{ lib, m, mod, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
    ./ugreen-wifi.nix
    mod.hardware.cpu-amd
    mod.hardware.nvidia-desktop
    m.desktop
    m.tour
    m.terminal
    m.dev
  ];

  networking.hostName = "cleboost-brain";

  # Intel I211 — primary Ethernet when cable is plugged in
  networking.firewall.trustedInterfaces = [ "enp5s0" ];

  # Titan X Pascal → legacy 580 branch (6xx driver rejects the card)

  boot.kernelParams = [
    "pcie_aspm.policy=performance"
  ];

  boot.kernelModules = lib.mkAfter [ "kvm-amd" ];
}
