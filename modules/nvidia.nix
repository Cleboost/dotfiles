# Graphics configuration module: NVIDIA + AMD PRIME
{ config, pkgs, ... }:

{
  # Display driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # OpenGL / Vulkan hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Proprietary NVIDIA driver configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME: AMD iGPU (laptop panel) + NVIDIA dGPU (external monitors)
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
      sync.enable = true;
    };
  };
}
