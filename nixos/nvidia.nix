# ──────────────────────────────────────────────────────────────────────────────
# nixos/nvidia.nix — NVIDIA + AMD PRIME (import on NVIDIA hosts only)
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # PRIME: AMD iGPU (laptop panel) + NVIDIA dGPU (external monitors)
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
      sync.enable = true;
    };
  };
}
