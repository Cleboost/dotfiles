# UGREEN AX900 USB Wi-Fi (USB ID a69c:5723 → a69c:8d80 after mode switch).
#
# radxa-pkg/aic8800 builds on 6.1; cfg80211 API on 6.12.101+ / 7.x still breaks
# with current nixpkgs kernels (xanmod 7.2 tested). Brain stays on 6.1 LTS.
{ config, pkgs, lib, ... }:

let
  kernelPackages = pkgs.linuxPackages_6_1;
  aic8800-firmware = pkgs.callPackage ../../system/pkgs/aic8800-firmware.nix { };
  aic8800-usb = kernelPackages.callPackage ../../system/pkgs/aic8800.nix {
    inherit aic8800-firmware;
  };
in
{
  boot.kernelPackages = lib.mkForce kernelPackages;

  hardware.usb-modeswitch.enable = true;

  # Nix cannot install etc names with ':' — call usb_modeswitch from udev instead.
  services.udev.extraRules = lib.mkAfter ''
    # UGREEN AX900 (a69c:5723) — fake mass-storage → WLAN (8d80)
    ACTION=="add|bind", SUBSYSTEM=="usb", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5723", RUN+="${lib.getExe pkgs.usb-modeswitch} -KQ -v 0xa69c -p 0x5723"
  '';

  boot.extraModulePackages = [ aic8800-usb ];
  boot.kernelModules = [
    "aic_load_fw"
    "aic8800_fdrv"
  ];

  hardware.firmware = [ aic8800-firmware ];

  # Only Wi-Fi NIC on this host → usually wlan0 after driver load.
  networking.firewall.trustedInterfaces = lib.mkAfter [ "wlan0" ];
}
