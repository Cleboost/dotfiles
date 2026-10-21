# UGREEN AX900 USB Wi-Fi (USB ID a69c:5723 → a69c:8d80 after mode switch).
#
# Driver radxa-pkg/aic8800 ne compile pas sur xanmod 7.2 (cfg80211). Wi-Fi désactivé
# pour l'instant — brain reste sur kernel xanmod (system/boot.nix). Réactiver avec
# enable = true + pin linuxPackages_6_1 quand on aura tranché.
{ config, pkgs, lib, ... }:

let
  enableUgreekWifi = false;

  aic8800-firmware = pkgs.callPackage ../../system/pkgs/aic8800-firmware.nix { };
  aic8800-usb = pkgs.linuxPackages_6_1.callPackage ../../system/pkgs/aic8800.nix {
    inherit aic8800-firmware;
  };
in
lib.mkMerge [
  {
    hardware.usb-modeswitch.enable = true;

    # Nix cannot install etc names with ':' — call usb_modeswitch from udev instead.
    services.udev.extraRules = lib.mkAfter ''
      # UGREEN AX900 (a69c:5723) — fake mass-storage → WLAN (8d80)
      ACTION=="add|bind", SUBSYSTEM=="usb", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5723", RUN+="${lib.getExe pkgs.usb-modeswitch} -KQ -v 0xa69c -p 0x5723"
    '';
  }
  (lib.mkIf enableUgreekWifi {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_1;

    boot.extraModulePackages = [ aic8800-usb ];
    boot.kernelModules = [
      "aic_load_fw"
      "aic8800_fdrv"
    ];

    hardware.firmware = [ aic8800-firmware ];

    networking.firewall.trustedInterfaces = lib.mkAfter [ "wlan0" ];
  })
]
