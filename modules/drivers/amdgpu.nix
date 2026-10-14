{ lib, pkgs, config, ... }:

let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = lib.mkEnableOption "AMD GPU drivers and ROCm support";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
