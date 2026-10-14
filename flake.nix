{
  description = "Cleboost's modular NixOS and Home Manager configuration";

  # ── Flake inputs ────────────────────────────────────────────────────────────
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };

    chatgpt-desktop = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grok-bot = {
      url = "github:jordangarrison/grok-bot-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-rustdesk-pr = {
      url = "github:telometto/nixpkgs/86fb8aca9dcd694480c58b087dc73f8b1ed5d38b";
    };
  };

  # ── NixOS configurations (one per hosts/<name>/ folder) ───────────────────
  outputs = { self, nixpkgs, home-manager, noctalia, noctalia-greeter, ... }@inputs:
    let
      hosts = [
        "cleboost-sage"
        "cleboost-brain"
        "cleboost-demo"
      ];

      mkHost = hostName: { live ? false }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs hostName; };
        modules = [
          ./nixos
          ./hosts/${hostName}/default.nix
          noctalia.nixosModules.default
          noctalia-greeter.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs hostName; };
            home-manager.users.cleboost = import ./home;
          }
        ] ++ (if live then [
          ./nixos/demo-live.nix
        ] else [
          ./hosts/${hostName}/hardware-configuration.nix
        ]);
      };
    in
    {
      nixosConfigurations = (nixpkgs.lib.genAttrs hosts (host: mkHost host { })) // {
        cleboost-demo-live = mkHost "cleboost-demo" { live = true; };
      };

      # nix build .#demo-iso -> result/iso/*.iso (bootable USB / VM).
      packages.x86_64-linux.demo-iso =
        self.nixosConfigurations.cleboost-demo-live.config.system.build.isoImage;
    };
}
