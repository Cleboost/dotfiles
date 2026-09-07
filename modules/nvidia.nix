# Module de configuration graphique NVIDIA + AMD PRIME
{ config, pkgs, ... }:

{
  # Pilote d'affichage
  services.xserver.videoDrivers = [ "nvidia" ];

  # Accélération matérielle OpenGL / Vulkan
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configuration du pilote propriétaire NVIDIA
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME : Association AMD iGPU (portable) + NVIDIA dGPU (écrans externes)
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
      sync.enable = true;
    };
  };
}
