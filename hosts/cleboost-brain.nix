{ inputs, config, ... }:
let
  m = config.flake.modules.nixos;
in {
  flake.nixosConfigurations.cleboost-brain = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./_hrdw-cleboost-brain.nix
      ./_cleboost-brain/storage.nix
      ./_cleboost-brain/ugreen-wifi.nix

      # Briques communes
      m.core
      m.desktop
      m.dev
      m.discord
      m.spotify

      # Briques spécifiques à la tour (dual ASUS, workspaces 1-10 / 11-20)
      m.tower

      ({ config, lib, ... }: {
        networking.hostName = "cleboost-brain";
        networking.firewall.trustedInterfaces = [ "enp5s0" ];

        # Titan X Pascal → legacy 580 branch
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.graphics.enable = true;
        hardware.nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        };

        boot.kernelParams = [
          "pcie_aspm.policy=performance"
        ];
        boot.kernelModules = lib.mkAfter [ "kvm-amd" ];

        system.stateVersion = "24.11";
      })
    ];
  };
}
