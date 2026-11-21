# Placeholder — nixos-anywhere / disko usually regenerate this file.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
      "xhci_pci"
    ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
