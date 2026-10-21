# UGREEN AX900 USB Wi-Fi (USB ID a69c:5723 → a69c:8d80 after mode switch).
#
# Vendor aic8800 driver does not build on kernel 6.12+ (cfg80211 API). Until upstream
# catches up, brain stays on 6.1 LTS so the dongle module can load.
{ config, pkgs, lib, ... }:

let
  aic8800-firmware = pkgs.callPackage ../../pkgs/aic8800-firmware.nix { };
  aic8800-usb = config.boot.kernelPackages.callPackage ../../pkgs/aic8800.nix {
    inherit aic8800-firmware;
  };
in
{
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_1;

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
