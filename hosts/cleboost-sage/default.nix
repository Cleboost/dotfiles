# Laptop — matériel et système uniquement.
{ config, pkgs, ... }:

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

  boot.kernelParams = [
    "btusb.enable_autosuspend=0"
    "usbcore.autosuspend=-1"
    "mt7921e.disable_aspm=1"
    "pcie_aspm.policy=performance"
  ];

  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=0 reset=1
    options mt7921e disable_aspm=1
  '';

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3563", ATTR{power/control}="on"
  '';

  hardware.flipperzero.enable = true;
}
