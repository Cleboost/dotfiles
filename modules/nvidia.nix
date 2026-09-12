# Graphics configuration module: NVIDIA + AMD PRIME
{ config, pkgs, ... }:

{
  # Early KMS for AMD iGPU to ensure display is ready before greetd (avoids race condition with dock stations)
  boot.initrd.kernelModules = [ "amdgpu" ];

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
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # PRIME: AMD iGPU (laptop panel) + NVIDIA dGPU (external monitors)
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
      sync.enable = true;
    };
  };
}
