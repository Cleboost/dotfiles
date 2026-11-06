# Laptop — matériel et système uniquement.
{ ... }:

{
  imports = [
    ../../system
    ../../system/drivers
    ../../home/hosts/cleboost-sage/groups.nix
    ./hardware-configuration.nix
  ];

  drivers.nvidia = {
    enable = true;
    prime.enable = true;
  };
  drivers.asus-fan-control.enable = true;

  networking.hostName = "cleboost-sage";
  networking.firewall.trustedInterfaces = [ "wlp3s0" ];

  # Aquamarine splits AQ_DRM_DEVICES on ':'. The by-path node contains colons,
  # so Hyprland gets a colon-free symlink to the AMD iGPU only.
  systemd.tmpfiles.rules = [
    "L+ /run/dri/amd-card - - - - /dev/dri/by-path/pci-0000:06:00.0-card"
  ];

  hardware.flipperzero.enable = true;
}
