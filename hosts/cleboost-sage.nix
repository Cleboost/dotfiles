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
        system.stateVersion = "24.11";
      })
    ];
  };
}
