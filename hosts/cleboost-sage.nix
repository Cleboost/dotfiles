{ inputs, config, ... }:
let
  m = config.flake.modules.nixos;
in {
  flake.nixosConfigurations.cleboost-sage = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./_hrdw-cleboost-sage.nix

      # Briques communes
      m.core
      m.desktop
      m.dev
      m.discord
      m.spotify

      # Briques spécifiques au portable (écran eDP-1, touchpad, batterie, barre Noctalia portable...)
      m.laptop

      ({ ... }: {
        networking.hostName = "cleboost-sage";
        networking.firewall.trustedInterfaces = [ "wlp3s0" ];

        # Aquamarine splits AQ_DRM_DEVICES on ':'. The by-path node contains colons,
        # so Hyprland gets a colon-free symlink to the AMD iGPU only.
        systemd.tmpfiles.rules = [
          "L+ /run/dri/amd-card - - - - /dev/dri/by-path/pci-0000:06:00.0-card"
        ];

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

        hardware.flipperzero.enable = true;
        system.stateVersion = "24.11";
      })
    ];
  };
}
