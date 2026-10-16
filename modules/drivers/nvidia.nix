# ──────────────────────────────────────────────────────────────────────────────
# nixos/nvidia.nix — NVIDIA + AMD PRIME (import on NVIDIA hosts only)
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

let
  cfg = config.drivers.nvidia;
in
{
  options.drivers.nvidia = {
    enable = lib.mkEnableOption "NVIDIA + AMD PRIME driver configuration";
  };

  config = lib.mkIf cfg.enable {
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # PRIME: AMD iGPU default (power-saving) + NVIDIA dGPU on-demand (offload)
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
};
}
