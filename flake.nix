{
  description = "Cleboost's NixOS and Home Manager configuration";

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

  outputs = { self, nixpkgs, home-manager, noctalia, noctalia-greeter, ... }@inputs:
    let
      username = "cleboost";

      hosts = [
        "cleboost-sage"
        "cleboost-brain"
        "cleboost-demo"
      ];

      # Each hosts/<name>/default.nix imports shared modules + its hardware.
      mkHost = hostName: { live ? false }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs hostName username live; };
        modules = [
          ./hosts/${hostName}
          noctalia.nixosModules.default
          noctalia-greeter.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs hostName username; };
            home-manager.users.${username} = import ./modules/home;
          }
        ];
      };
    in
    {
      nixosConfigurations = (nixpkgs.lib.genAttrs hosts (host: mkHost host { })) // {
        cleboost-demo-live = mkHost "cleboost-demo" { live = true; };
      };

      packages.x86_64-linux = {
        demo-iso =
          self.nixosConfigurations.cleboost-demo-live.config.system.build.isoImage;
        pdfcraft =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/pdfcraft.nix { };
        codex-chatgpt-web =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/codex-chatgpt-web.nix { };
        antigravity-cli =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/antigravity-cli.nix { };
      };
    };
}
