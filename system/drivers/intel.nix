{ lib, pkgs, config, ... }:

let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = lib.mkEnableOption "Intel Graphics Drivers and hardware acceleration";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        vpl-gpu-rt
      ];
    };
  };
}
