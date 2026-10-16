# ──────────────────────────────────────────────────────────────────────────────
# modules/drivers/nvidia.nix — NVIDIA (single GPU or AMD PRIME on laptops)
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

let
  cfg = config.drivers.nvidia;
  primeCfg = cfg.prime;
in
{
  options.drivers.nvidia = {
    enable = lib.mkEnableOption "Proprietary NVIDIA driver stack";

    packageFlavour = lib.mkOption {
      type = lib.types.enum [
        "latest"
        "production"
        "stable"
        "legacy_580"
        "legacy_535"
        "legacy_470"
      ];
      default = "latest";
      description = ''
        NVIDIA driver branch from boot.kernelPackages.nvidiaPackages.
        Pascal (ex. Titan X) needs legacy_580 — latest 6xx ignores the GPU.
      '';
    };

    prime = {
      enable = lib.mkEnableOption "AMD iGPU + NVIDIA dGPU PRIME offload (laptop)";
      amdgpuBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:6:0:0";
        description = "AMD integrated GPU bus ID for PRIME.";
      };
      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:1:0:0";
        description = "NVIDIA discrete GPU bus ID for PRIME.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = lib.mkIf primeCfg.enable [ "amdgpu" ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = primeCfg.enable;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.packageFlavour};
    } // lib.optionalAttrs primeCfg.enable {
      prime = {
        amdgpuBusId = primeCfg.amdgpuBusId;
        nvidiaBusId = primeCfg.nvidiaBusId;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
}
