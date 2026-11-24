{ ... }: {
  # 1. Variante Tour (Titan X Pascal → legacy 580)
  flake.mod.hardware.nvidia-desktop = { config, pkgs, ... }:
    let
      nvPkg = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    in {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics.enable = true;

      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = nvPkg;
      };

      environment.etc."X11/xorg.conf.d/20-nvidia-coolbits.conf".text = ''
        Section "Device"
          Identifier "Nvidia Card"
          Driver "nvidia"
          Option "Coolbits" "4"
        EndSection
      '';

      environment.systemPackages = [
        pkgs.xorg.xhost
        (pkgs.callPackage ../../pkgs/gpu-fan.nix {
          nvidiaSmi = nvPkg.bin;
          nvidiaSettings = nvPkg.settings;
        })
        (pkgs.callPackage ../../pkgs/nvidia-gaming.nix {
          nvidiaSmi = nvPkg.bin;
        })
      ];
    };

  # 2. Variante Portable (Hybride AMD iGPU + Nvidia Prime Offload)
  flake.mod.hardware.nvidia-hybrid = { ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
