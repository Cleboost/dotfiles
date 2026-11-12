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

    coolbits = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = ''
        Écrit Option Coolbits dans /etc/X11/xorg.conf.d (lu par XWayland).
        Sans services.xserver.enable, services.xserver.config est ignoré.
        4 = ventilo manuel ; 28 = ventilo + clocks. Reboot ou relog XWayland après changement.
        Commandes : gpu-fan, nvidia-gaming (toggle 100 % + 300 W).
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

    environment.etc = lib.mkIf (cfg.coolbits != 0) {
      "X11/xorg.conf.d/21-nvidia-coolbits.conf".text = ''
        Section "Device"
          Identifier "cleboost-nvidia-coolbits"
          Driver "nvidia"
          Option "Coolbits" "${toString cfg.coolbits}"
        EndSection
      '';
    };

    environment.systemPackages = lib.mkIf (cfg.coolbits != 0) (
      let
        nvPkg = config.boot.kernelPackages.nvidiaPackages.${cfg.packageFlavour};
      in
      [
        pkgs.xorg.xhost
        (pkgs.callPackage ../pkgs/gpu-fan.nix {
          nvidiaSmi = nvPkg.bin;
          nvidiaSettings = nvPkg.settings;
        })
        (pkgs.callPackage ../pkgs/nvidia-gaming.nix {
          nvidiaSmi = nvPkg.bin;
        })
      ]
    );

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
