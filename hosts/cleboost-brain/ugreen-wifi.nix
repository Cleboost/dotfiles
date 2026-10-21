# UGREEN AX900 USB Wi-Fi (USB ID a69c:5723 → a69c:8d80 after mode switch).
#
# radxa-pkg/aic8800 + debian kernel patches in system/pkgs/aic8800-patches/.
# Temporary until upstream ships xanmod 7.2+ support without local patches.
{ config, pkgs, lib, ... }:

let
  aic8800-src = pkgs.callPackage ../../system/pkgs/aic8800-src.nix { };
  aic8800-firmware = pkgs.callPackage ../../system/pkgs/aic8800-firmware.nix {
    inherit aic8800-src;
  };
  aic8800-usb = config.boot.kernelPackages.callPackage ../../system/pkgs/aic8800.nix {
    inherit aic8800-src;
  };
in
{
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
