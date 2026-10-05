# cleboost-sage — laptop actuel (AMD + NVIDIA PRIME, ASUS, Wi-Fi MediaTek, …)
{ config, pkgs, ... }:

{
  imports = [
    ../../nixos/nvidia.nix
    ./asus-fan-control.nix
  ];

  networking.hostName = "cleboost-sage";
  networking.firewall.trustedInterfaces = [ "wlp3s0" ];

  boot.kernelParams = [
    "btusb.enable_autosuspend=0"
    "usbcore.autosuspend=-1"
    "mt7921e.disable_aspm=1"
    "pcie_aspm.policy=performance"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=20 card_label="Phone Camera" exclusive_caps=1
    options btusb enable_autosuspend=0 reset=1
    options mt7921e disable_aspm=1
  '';

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3563", ATTR{power/control}="on"
  '';

  hardware.flipperzero.enable = true;
}
